# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing users via API v1
    class UsersController < ApplicationController
      def index
        users = ApplicationRepository::DB[:users].all

        render body: users.to_json, headers: { 'content-type' => 'application/json' }
      end

      def update
        user = ApplicationRepository::DB[:users].where(id: params[:id]).first
        params = user.merge(request_params)
        ApplicationRepository::DB[:users].where(id: params[:id]).update(params)

        head 204
      end

      def create
        ApplicationRepository::DB[:users].insert(request_params)

        head 204
      end

      def show
        user = ApplicationRepository::DB[:users].where(id: params[:id]).first

        render body: user.to_json, headers: { 'content-type' => 'application/json' }
      end

      def delete
        ApplicationRepository::DB[:users].where(id: params[:id]).delete

        head 204
      end
    end
  end
end
