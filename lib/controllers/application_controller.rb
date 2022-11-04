# frozen_string_literal: true

require 'slim/include'
require 'json'

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
    send(action)
  end

  def render(code: DEFAULT_HTTP_CODE, head: nil, headers: {}, body: nil, template: nil, layout: DEFAULT_LAYOUT, locals: {}, json: nil)
    return [head, headers, nil] unless head.nil?
    return [code, headers, [body]] unless body.nil?
    return [code, headers.merge({ 'content-type' => 'application/json' }), [json.to_json]] unless json.nil?

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

  def request_params
    return @request_params if defined?(@request_params)
    return @request_params = {} if request.body.nil?

    @request_params =
      case request.content_type
      when 'application/json' then JSON.parse(request.body.read).transform_keys(&:to_sym)
      else request.params.transform_keys(&:to_sym)
      end
    @request_params
  end

  private

  def template_path(action)
    path = self.class.to_s.delete_suffix('Controller').split('::').map(&:downcase).join('/')
    "./app/views/#{path}/#{action}.slim"
  end
end
