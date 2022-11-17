# frozen_string_literal: true

module Web
  # Handler for users page
  class UsersController < ApplicationController
    def create
      # require 'securerandom'
      # email, password, password_confirmation
      contract = UserCreateContract.new.call(request_params)

      salt = SecureRandom.hex(4)
      password_hash = BCrypt::Password.create(salt + contract[:password])
      # TODO:
      # https://github.com/bcrypt-ruby/bcrypt-ruby
      # add password_hash string, salt string to users
      # user
      # UserRepository
    end
  end
end
