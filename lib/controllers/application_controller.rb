require 'slim/include'

class ApplicationController
  DEFAULT_LAYOUT = './app/views/application_layout.slim'
  DEFAULT_HTTP_CODE = 200

  attr_accessor :env
  attr_reader :action, :params, :request

  def initialize(env, params, request)
    @env = env
    @params = params
    @request = request
  end

  def resolve(action)
    @action = action
    self.send(action)
  end

  def render(code: DEFAULT_HTTP_CODE, head: nil, headers: {}, body: nil, template: nil, layout: DEFAULT_LAYOUT, locals: {})
    return [head, headers, nil] unless head.nil?
    return [code, headers, [body]] unless body.nil?

    template ||= template_path(action)
    body =
      if layout.nil?
        Slim::Template.new(template).render(locals)
      else
        Slim::Template.new(layout).render(self) do
          Slim::Template.new(template).render(locals)
        end
      end
    [code, headers, [body]]
  end

  private

  def template_path(action)
    path = self.class.to_s.delete_suffix('Controller').split('::').map(&:downcase).join('/')
    "./app/views/#{path}/#{action}.slim"
  end
end