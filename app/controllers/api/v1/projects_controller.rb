# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing projects via API v1
    class ProjectsController < ApplicationController
      def index
        projects = ProjectRepository.all
        props = [:id, :title, :description]
        data = projects.map do |p|
          p.to_h.select { |key| props.include? key }
        end

        render body: data.to_json, headers: { 'content-type' => 'application/json' }
      end

      def create
        validation_result = ProjectContract.new.call(request_params)
        return render(
          code: 422, body: validation_result.errors.to_h.to_json,
          headers: { 'content-type' => 'application/json' }
        ) if validation_result.failure?

        project = Project.new(validation_result.to_h)
        ProjectRepository.create(project)

        head 201
      end

      def update
        validation_result = ProjectContract.new.call(request_params)
        if validation_result.success?
          project = Project.new(request_params.merge({ id: params[:id] }))
          persisting_result = ProjectRepository.save(project)
          return head 204 if persisting_result == 1

          render code: 422, body: persisting_result.errors
        else
          render code: 422, body: validation_result.errors
        end
      end
      #
      # def create
      #   ApplicationRepository::DB[:users].insert(request_params)
      #
      #   head 204
      # end
      #
      # def show
      #   user = ApplicationRepository::DB[:users].where(id: params[:id]).first
      #
      #   render body: user.to_json, headers: { 'content-type' => 'application/json' }
      # end
      #
      # def delete
      #   ApplicationRepository::DB[:users].where(id: params[:id]).delete
      #
      #   head 204
      # end
    end
  end
end
