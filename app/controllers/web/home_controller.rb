# frozen_string_literal: true

module Web
  # Handler for start page
  class HomeController < Web::ApplicationController
    def index
      @projects = ProjectRepository.all({ user_id: current_user.id }) unless current_user.nil?
      render
    end

    def signup
      render
    end
  end
end
