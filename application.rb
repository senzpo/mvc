Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }

class Application
  def initialize
    @router = Router.new
    # @controller = Controller.new
  end

  def call(env)
    result = @router.resolve(env)

    result.controller
    result.method

    Controller.new(env).result
    # [200, {"Content-Type" => "text/html"}, ["Hello Rack Participants!!!"]]
  end
end
