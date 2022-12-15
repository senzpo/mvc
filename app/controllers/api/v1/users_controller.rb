# frozen_string_literal: true

module Api
  module V1
    # Provides handlers for managing users via API v1
    class UsersController < ActionController
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
          create_with_valid_contract(contract)
        end
      end

      def show
        user = ApplicationRepository::DB[:users].where(id: params[:id]).first

        render body: user.to_json, headers: { 'content-type' => 'application/json' }
      end

      def delete
        return head 403 unless same_user?

        Services::Users::Delete.new.call(params) do |m|
          m.success do |_|
            head 204
          end

          m.failure do |_|
            # TODO: some errors handle here
            head 401
          end
        end
      end

      private

      def same_user?
        current_user && current_user.id.to_s == params[:id]
      end

      def create_with_valid_contract(contract)
        Services::Users::Create.new.call(contract.to_h) do |m|
          m.success { head 204 }
          m.failure do |errors|
            render code: 422, body: errors.to_json, headers: { 'content-type' => 'application/json' }
          end
        end
      end
    end
  end
end
