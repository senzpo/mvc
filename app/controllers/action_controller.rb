# frozen_string_literal: true

# Main application controller
class ActionController < ApplicationController
  def current_user
    user_id =
      if Application::Config.test?
        env['test'] ? env['test']['user_id'] : nil
      else
        session = env['rack.session']
        session ? session[:user_id] : nil
      end
    UserRepository.all(id: user_id).first
  end
end
