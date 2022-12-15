# frozen_string_literal: true

require 'yaml'

# Rack friendly launcher for project
class Application
  # Main application config
  class Config
    def self.env
      ENV.fetch('APP_ENV', 'development')
    end

    def self.test?
      env == 'test'
    end
  end

  def initialize
    @router = RegexpRouter.new(File.join(File.dirname(__FILE__), 'app', 'config', 'routes.rb'))
  end

  def call(env)
    request = Rack::Request.new(env)
    result = @router.resolve(request.path, request.request_method)
    controller = result.controller.new(env, result.params, request)
    controller.resolve(result.action)
  end
end

Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each { |file| require file }
