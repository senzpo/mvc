# frozen_string_literal: true

module Web
  # Handler for sessions
  class SessionsController < Web::ApplicationController
    def new
      render
    end

    def create
      user = get_user(request_params[:email])
      return head 302, headers: { 'Location' => '/login' } if user.nil?

      return head 302, headers: { 'Location' => '/login' } unless valid_password?(user, request_params[:password])

      session = env['rack.session']
      session[:user_id] = user.id

      head 302, headers: { 'Location' => '/' }
    end

    def delete
      session = env['rack.session']
      session[:user_id] = nil if session
      head 302, headers: { 'Location' => '/' }
    end

    private

    def get_user(email)
      UserRepository.all(email: email).first
    end

    def valid_password?(user, password)
      tested_password = BCrypt::Password.new(user.password_hash)
      tested_password == user.salt + password
    end
  end
end
