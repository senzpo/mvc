# frozen_string_literal: true

module Web
  # Web controller with current_user methods
  class ApplicationController < ActionController
    def resolve(action)
      super(action)
    rescue UnauthorizedError
      head 302, headers: { 'Location' => '/login' }
    end
  end
end
