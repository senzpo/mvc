# frozen_string_literal: true

# Web interface
module Services
  module Users
    require 'securerandom'

    class Create
      include Dry::Transaction

      step :validate
      step :create
      step :assign_default_project
      step :send_welcome_email

      private

      def validate(params)
        contract = UserCreateContract.new.call(params)
        if contract.success?
          Success(contract)
        else
          Failure(contract)
        end
      end

      def create(contract)
        salt = SecureRandom.hex(4)
        password_hash = BCrypt::Password.create(salt + contract[:password])
        user_params = contract.to_h.slice(:email).merge({ password_hash: password_hash, salt: salt })
        user = UserRepository.create(user_params)
        Success(user)
      end
    end
  end
end
