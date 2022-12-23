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
      @projects = ProjectRepository.all({ user_id: current_user.id })
      render
    end

    def show
      @project = ProjectRepository.find(id: params[:id], user_id: current_user.id)
      render
    end

    def delete
      project = ProjectRepository.find(id: params[:id], user_id: current_user.id)
      Services::Projects::Delete.new.call(project) unless project.nil?
      head 303, headers: { 'Location' => '/projects' }
    end

    def create
      project_params = request_params.merge(user_id: current_user.id)
      Services::Projects::Create.new.call(project_params) do |m|
        m.success { head 303, headers: { 'Location' => '/projects' } }
        m.failure do |errors|
          @params = { project: request_params, errors: errors.errors.to_h }
          render template: './app/views/web/projects/new.slim'
        end
      end
    end
  end
end
