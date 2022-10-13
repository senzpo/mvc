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
      method.to_s == http_method.to_s && Regexp.new(pattern).match?(path)
    end
  end

  class Result
    attr_reader :route, :path

    def initialize(route, path)
      @route = route
      @path = path
    end

    def controller
      eval "#{route.controller.capitalize}Controller"
    end

    def action
      route.action
    end

    def params

    end
  end

  attr_reader :routes

  def initialize(route_path)
    @routes = []
    load_routes(route_path)
  end

  def resolve(path, method)
    route = routes.find { |route| route.matched?(path, method)}
    if route
      return Result.new(route, path)
    end
    # /\/\:(\w*)/.match "/users/:id/tags/:tag_id"
    # if route
    # 2.7.4 :088 > "/users/:id/tags/:tag_id".scan(/\/\:(\w*)/).flatten
    # => ["id", "tag_id"]
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
    controller, action = options[:to].split('#')
    @routes << Route.new(controller: controller, action: action, pattern: pattern, method: method)
  end
end
