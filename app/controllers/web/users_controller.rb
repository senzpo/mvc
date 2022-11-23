# frozen_string_literal: true

module Web
  # Handler for users page
  class UsersController < ApplicationController
    def create
      require 'securerandom'

      contract = UserCreateContract.new.call(request_params)
      if contract.failure?
        # TODO render error somehow
        return
      end

      salt = SecureRandom.hex(4)
      password_hash = BCrypt::Password.create(salt + contract[:password])
      user_params = contract.to_h.slice(:email).merge({password_hash: password_hash, salt: salt})
      UserRepository.create(user_params)
      # head 303, headers: { 'location' => '/login' }
      # doesn't work?
      render code: 303, headers: { 'location' => '/login' }, body: 'User created'
    end
  end
end
