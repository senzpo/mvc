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
        Services::Users::Create.new.call(contract) do |m|
          m.success do |_|
            head 303, headers: { 'location' => '/' }
          end

          m.failure do |_|
            create_with_errors({})
          end
        end
      end
    end

    private

    def create_with_errors(contract)
      @params = { user: contract.to_h, errors: contract.errors.to_h }
      render
    end

    def create_with_valid_contract(contract)
      salt = SecureRandom.hex(4)
      password_hash = BCrypt::Password.create(salt + contract[:password])
      user_params = contract.to_h.slice(:email).merge({ password_hash: password_hash, salt: salt })
      UserRepository.create(user_params)
      head 303, headers: { 'location' => '/' }
    end
  end
end
