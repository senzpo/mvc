# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing projects via API v1
    class ProjectsController < ActionController
      before_action :authenticate_user!

      def index
        projects = ProjectRepository.all

        json = Api::V1::Projects::BaseSerializer.new(projects).serialize.to_json
        render body: json, headers: { 'content-type' => 'application/json' }
      end

      def create
        contract = ProjectContract.new.call(request_params.merge(user_id: current_user.id))
        if contract.failure?
          return render(
            code: 422, body: contract.errors.to_h.to_json,
            headers: { 'content-type' => 'application/json' }
          )
        end

        project = ProjectRepository.create(contract.to_h)
        render code: 201, body: project.to_h.to_json, headers: { 'content-type' => 'application/json' }
      end

      def update
        contract = ProjectContract.new.call(request_params.merge(user_id: current_user.id))
        if contract.success?
          ProjectRepository.update(params[:id], contract.to_h)

          head 204
        else
          render code: 422, body: contract.errors
        end
      rescue ApplicationRepository::NotFoundRecord
        head 404
      end

      def delete
        ProjectRepository.delete(params[:id])

        head 204
      rescue ApplicationRepository::NotFoundRecord
        head 404
      end

      def show
        project = ProjectRepository.find(id: params[:id], user_id: current_user.id)

        json = Api::V1::Projects::BaseSerializer.new(project).serialize.to_json
        render body: json, headers: { 'content-type' => 'application/json' }
      rescue ApplicationRepository::NotFoundRecord
        head 404
      end
    end
  end
end
