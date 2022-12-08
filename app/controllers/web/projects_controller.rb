# frozen_string_literal: true

module Web
  # Handler for start page
  class ProjectsController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      render
    end

    def show
      render
    end

    private

    def authenticate_user!
      raise UnauthorizedError unless current_user
    end
  end
end
