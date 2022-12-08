# frozen_string_literal: true

module Web
  class UnauthorizedError < StandardError; end

  # Web controller with current_user methods
  class ApplicationController < ::ApplicationController
    def current_user
      session = env['rack.session']
      return nil unless session

      UserRepository.all(id: session[:user_id]).first
    end

    def resolve(action)
      super(action)
    rescue UnauthorizedError
      head 302, headers: { 'Location' => '/login' }
    end
  end
end
