# frozen_string_literal: true

module Web
  # Handler for start page
  class ProjectsController < Web::ApplicationController
    before_action :authenticate_user!

    def new
      @params = { project: {} }
      render
    end

    def index
      @projects = ProjectRepository.all({user_id: current_user.id})
      render
    end

    def show
      render
    end

    def create
      project_params = request_params.merge(user_id: current_user.id)
      Services::Projects::Create.new.call(project_params) do |m|
        m.success { head 303, headers: { 'location' => '/projects' } }
        m.failure do |errors|
          @params = { project: request_params, errors: errors.errors.to_h }
          render template: "./app/views/web/projects/new.slim"
        end
      end
    end
  end
end
