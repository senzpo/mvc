# frozen_string_literal: true

module Web
  # Web controller with current_user methods
  class Web::ApplicationController < ::ApplicationController
    def current_user
      session = env['rack.session']
      user = UserRepository.all(id: session[:user_id]).first
      user
    end

    def render(*args)
      @current_user = current_user
      super
    end
  end
end
