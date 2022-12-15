# frozen_string_literal: true

# Main application controller
class ActionController < ApplicationController
  def current_user
    session = env['rack.session']
    UserRepository.all(id: session[:user_id]).first
  end
end
