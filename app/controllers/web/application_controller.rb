# frozen_string_literal: true

module Web
  # Web controller with current_user methods
  class ApplicationController < ::ApplicationController
    def current_user
      session = env['rack.session']
      return nil unless session

      UserRepository.all(id: session[:user_id]).first
    end

    def render(*args)
      @current_user = current_user
      super
    rescue Application::NotFoundError
      render 404_page
    rescue UnAuthError
      redirect
    end
  end
end
