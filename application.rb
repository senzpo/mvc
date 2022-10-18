Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'app', '**','*.rb')].each {|file| require file }

class Application
  class NotFoundError < StandardError; end

  def self.db
    @@db ||= Sequel.connect('sqlite://blog.db')
  end

  def initialize
    @router = RegexpRouter.new(File.join(File.dirname(__FILE__), 'app', 'config', 'routes.rb'))
  end

  def call(env)
    request = Rack::Request.new(env)

    result = @router.resolve(request.path, request.request_method)

    if result
      controller = result.controller.new(env, result.params)
      controller.resolve(result.action)
    else
      raise NotFoundError
    end
  end
end
