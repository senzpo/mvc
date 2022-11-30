# frozen_string_literal: true

module Web
  # Handler for sessions
  class SessionsController < Web::ApplicationController
    def new
      render
    end

    def create
      user = UserRepository.all(email: request_params[:email]).first
      return head 302, headers: { 'Location' => '/login' } if user.nil?

      tested_password = BCrypt::Password.new(user.password_hash)
      unless tested_password == user.salt + request_params[:password]
        return head 302, headers: { 'Location' => '/login' }
      end

      session = env['rack.session']
      session[:user_id] = user.id
      head 302, headers: { 'Location' => '/' }
    end
  end
end
