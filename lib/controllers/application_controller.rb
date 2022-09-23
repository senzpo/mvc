class ApplicationController
  attr_accessor :env
  attr_reader :action

  def initialize(env)
    @env = env
  end

  def resolve(action)
    @action = action
    self.send(action)
  end

  def render(code:, headers: {}, body: nil, template: nil, no_content: false)
    template = "./app/views/users/#{action}.slim" if template == nil

    if template && !no_content
      body = Slim::Template.new(template).render(self)
    end

    http_body = body ? [body] : nil
    [code, headers, http_body]
  end

  #
  # def result
  #   result = Rack::Request.new(@env)
  #   # puts result.inspect
  #   result.path
  #
  #   paths = result.path.split('/')
  #
  #
  #
  #
  #   @year = 2022
  #   @author = 'Evg'
  #
  #
  #   db = Sequel.connect('sqlite://blog.db')
  #   @items = db[:items]
  #
  #   template = if paths[1] == 'users' && paths[2].nil?
  #                "./lib/views/index.slim"
  #              elsif paths[1] == 'users'
  #                "./lib/views/show.slim"
  #              else
  #                nil
  #              end
  #   code = template.nil? ? 404 : 200
  #   template ||= "./lib/views/404.slim"
  #   result = Slim::Template.new(template).render(self)
  #
  #
  #
  #   [code, {"Content-Type" => "text/html"}, [result]]
  # end
end