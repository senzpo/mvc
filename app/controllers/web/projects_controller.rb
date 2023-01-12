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

    def edit
      @project = ProjectRepository.find(id: params[:id], user_id: current_user.id)
      @params = { project: @project.to_h }
      render
    end

    def update
      @project = ProjectRepository.find(id: params[:id], user_id: current_user.id)
      project_params = @project.to_h.merge(request_params)
      Services::Projects::Update.new.with_step_args(update: [project: @project]).call(project_params) do |m|
        m.success { head 303, headers: { 'Location' => "/projects/#{@project.id}" } }
        m.failure do |errors|
          @params = { project: request_params, errors: errors.errors.to_h }
          render template: './app/views/web/projects/edit.slim'
        end
      end
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
