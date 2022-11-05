# frozen_string_literal: true

# Simple router based on dsl
# lambda do
#   get '/users/:id', to: 'web#users#show'
#   post '/users', to: 'web#users#create'
# end
# get, post, delete, etc - HTTP methods
# '/user', '/users/:id' - regexp, :id - params, available with result
# to: 'web#users#create' - route request to Web::UsersController create method
class RegexpRouter
  HTTP_METHODS = %w[get post patch put delete options head].freeze

  # concrete route
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

      pattern_matched_with?(pattern_split, path_split)
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

    private

    def pattern_matched_with?(pattern_split, path_split)
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
  end

  # result of searching right route, has controller, action, params from path
  class Result
    attr_reader :route, :path

    def initialize(route, path)
      @route = route
      @path = path
    end

    def controller
      instance_eval "#{route.controller}Controller", __FILE__, __LINE__
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
    route = routes.find { |r| r.matched?(path, method.downcase) }

    Result.new(route, path) if route
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
    controller = path_pieces.slice(0..-2).map(&:capitalize).join('::')
    action = path_pieces.last
    @routes << Route.new(controller: controller, action: action, pattern: pattern, method: method)
  end
end
