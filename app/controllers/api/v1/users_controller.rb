# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing users via API v1
    class UsersController < ApplicationController
      def index
        users = Application.db[:users].all

        render body: users.to_json, headers: { 'content-type' => 'application/json' }
      end

      def update
        user = Application.db[:users].where(id: params[:id]).first
        params = user.merge(request_params)
        Application.db[:users].where(id: params[:id]).update(params)

        head 204
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
