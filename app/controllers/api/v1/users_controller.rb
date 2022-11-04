# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = Application.db[:users].all

        render json: users
      end

      def update
        user = Application.db[:users].where(id: params[:id]).first
        params = user.merge(request_params)
        Application.db[:users].where(id: params[:id]).update(params)

        render head: 204
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
