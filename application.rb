Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'app', '**','*.rb')].each {|file| require file }

class Application
  class NotFoundError < StandardError;

  end
  def initialize
    @router = ApplicationRouter.new
  end

  def call(env)
    result = @router.resolve(path, method)
    if result.controller && result.action
      controller = eval(result.controller).new(env)
      controller.resolve(action)
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
