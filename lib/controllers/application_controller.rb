# frozen_string_literal: true

require 'slim/include'
require 'json'

# All app controllers must be subclasses of ApplicationController
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

  def render(code: DEFAULT_HTTP_CODE, headers: {}, body: nil, layout: DEFAULT_LAYOUT, locals: {})
    return [code, headers, [body]] unless body.nil?

    body = prepare_body(layout, template_path(action), locals)
    [code, headers, [body]]
  end

  def head(code, headers: {})
    [code, headers, []]
  end

  def request_params
    return @request_params if defined?(@request_params)
    return @request_params = {} if request.body.nil?

    @request_params =
      case request.content_type
      when 'application/json' then JSON.parse(request.body.read).transform_keys(&:to_sym)
      else request.params.transform_keys(&:to_sym)
      end
  end

  private

  def template_path(action)
    path = self.class.to_s.delete_suffix('Controller').split('::').map(&:downcase).join('/')
    "./app/views/#{path}/#{action}.slim"
  end

  def prepare_body(layout, template, locals)
    return Slim::Template.new(template).render(locals) if layout.nil?

    Slim::Template.new(layout).render(self) do
      Slim::Template.new(template).render(locals)
    end
  end
end
