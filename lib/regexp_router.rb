class RegexpRouter
  HTTP_METHODS = %w[get post patch put delete options head]

  class Route
    attr_reader :controller, :action, :pattern, :method

    def initialize(controller:, action:, pattern:, method:)
      @controller = controller
      @action = action
      @pattern = pattern
      @method = method
    end

    def matched?(path, http_method)
      return false unless method.to_s == http_method.to_s

      pattern_split = pattern.split('/')
      path_split = path.split('/')

      return false if pattern_split.length != path_split.length

      matched = true

      pattern_split.each_with_index do |e, index|
        next if e.start_with?(':')
        if e != path_split[index]
          matched = false
          break
        end
      end

      matched
    end

    def params(path)
      pattern_split = pattern.split('/')
      path_split = path.split('/')

      result = {}

      pattern_split.each_with_index do |e, index|
        if e.start_with?(':')
          key = e.delete(':').to_sym
          result[key] = path_split[index]
        end
      end

      result
    end
  end

  class Result
    attr_reader :route, :path

    def initialize(route, path)
      @route = route
      @path = path
    end

    def controller
      eval "#{route.controller}Controller"
    end

    def action
      route.action
    end

    def params
      route.params(path)
    end
  end

  attr_reader :routes

  def initialize(route_path)
    @routes = []
    load_routes(route_path)
  end

  def resolve(path, method)
    route = routes.find { |route| route.matched?(path, method.downcase)}

    if route
      return Result.new(route, path)
    end
  end

  private

  def load_routes(route_path)
    instance_eval(File.read(route_path), route_path.to_s).call
  end

  HTTP_METHODS.each do |method|
    define_method method do |pattern, options|
      register_route(method, pattern, options)
    end
  end

  def register_route(method, pattern, options)
    path_pieces = options[:to].split('#')
    controller = path_pieces.slice(0..-2).map { |s| s.capitalize }.join('::')
    action = path_pieces.last
    @routes << Route.new(controller: controller, action: action, pattern: pattern, method: method)
  end
end