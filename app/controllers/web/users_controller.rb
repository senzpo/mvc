# frozen_string_literal: true

# Web interface
module Web
  require 'securerandom'

  # Handler for users page
  class UsersController < ApplicationController
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
      params = contract.to_h
      render locals: { user: params, errors: contract.errors.to_h }
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
