# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing projects via API v1
    class ProjectsController < ApplicationController
      def index
        projects = ProjectRepository.all({})

        render body: projects.to_json, headers: { 'content-type' => 'application/json' }
      end

      def update
        validation_result = ProjectValidor.new.call(request_params)
        if validation_result.valid?
          persisting_result = ProjectRepository.update(params[:id], request_params)
          return head 204 if persisting_result.succes?

          render code: 422, body: persisting_result.errors
        else
          render code: 422, body: validation_result.errors
        end
      end

      def create
        Application.db[:users].insert(request_params)

        head 204
      end

      def show
        user = Application.db[:users].where(id: params[:id]).first

        render body: user.to_json, headers: { 'content-type' => 'application/json' }
      end

      def delete
        Application.db[:users].where(id: params[:id]).delete

        head 204
      end
    end
  end
end
