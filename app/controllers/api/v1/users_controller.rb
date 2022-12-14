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
        contract = UserCreateApiContract.new.call(request_params)
        if contract.failure?
          render code: 422, body: contract.errors.to_json, headers: { 'content-type' => 'application/json' }
        else
          Services::Users::Create.new.call(contract.to_h) do |m|
            m.success do |_|
              head 204
            end

            m.failure do |errors|
              render code: 422, body: errors.to_json, headers: { 'content-type' => 'application/json' }
            end
          end
        end
      end

      def show
        user = ApplicationRepository::DB[:users].where(id: params[:id]).first

        render body: user.to_json, headers: { 'content-type' => 'application/json' }
      end

      def delete
        return head 403 unless is_current_user?
        Services::Users::Delete.new.call(params) do |m|
          m.success do |_|
            head 204
          end

          m.failure do |_|
            # TODO some errors handle here
            head 401
          end
        end
      end

      private

      def is_current_user?
        @current_user && @current_user.id == params[:id]
      end
    end
  end
end
