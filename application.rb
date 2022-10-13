Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'app', '**','*.rb')].each {|file| require file }

class Application
  class NotFoundError < StandardError;

  end
  def initialize
    @router = RegexpRouter.new(File.join(File.dirname(__FILE__), 'app', 'config', 'routes.rb'))


  end

  def call(env)
    request = Rack::Request.new(env)
    # binding.pry
    result = @router.resolve(request.path, request.request_method.downcase)

    if result
      controller = result.controller.new(env)
      controller.resolve(result.action)
    else
      raise NotFoundError
    end
    # ApplicationRouter::Result
    # :controller, :action
    # # path
    # # method
    # # result = Rack::Request.new(@env)
    #
    # # result.path
    # # @env[:controller] = UsersController
    #
    # controller_class = 'UsersController'
    # action = 'index'

    # controller = eval(controller_class).new(env)
    # controller.resolve(action)
  end
end
