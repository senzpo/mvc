# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        projects = ProjectRepository.all({})

        render json: projects
      end

      def update
        validation_result = ProjectValidor.new.call(request_params)

        if validation_result.valid?
          persisting_result = ProjectRepository.update(params[:id], request_params)
          if persisting_result.succes?
            render head: 204
          else
            render code: 422, json: persisting_result.errors
          end
        else
          render code: 422, json: validation_result.errors
        end
      end

      def create
        Application.db[:users].insert(request_params)

        render head: 204
      end

      def show
        user = Application.db[:users].where(id: params[:id]).first

        render json: user
      end

      def delete
        Application.db[:users].where(id: params[:id]).delete

        render head: 204
      end
    end
  end
end
