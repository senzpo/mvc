# frozen_string_literal: true

# Main application controller
class ActionController < ApplicationController
  class UnauthorizedError < StandardError; end

  def current_user
    session = env['rack.session']
    UserRepository.all({ id: session[:user_id] }).first
  end

  private

  def authenticate_user!
    raise UnauthorizedError unless current_user
  end
end
