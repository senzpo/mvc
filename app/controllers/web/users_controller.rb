# frozen_string_literal: true

# Web interface
module Web
  require 'securerandom'

  # Handler for users page
  class UsersController < Web::ApplicationController
    def create
      contract = UserCreateContract.new.call(request_params)
      if contract.failure?
        create_with_errors(contract)
      else
        create_with_valid_contract(contract)
      end
    end

    private

    def create_with_errors(contract)
      @params = { user: contract.to_h, errors: contract.errors.to_h }
      render
    end

    def create_with_valid_contract(contract)
      Services::Users::Create.new.call(contract.to_h) do |m|
        m.success { head 303, headers: { 'location' => '/' } }
        m.failure { |errors| create_with_errors(errors) }
      end
    end
  end
end
