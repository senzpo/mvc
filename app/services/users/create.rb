# frozen_string_literal: true

# Web interface
module Services
  # Users services namespace
  module Users
    require 'securerandom'

    # Persist user with default project
    class Create
      include Dry::Transaction

      step :validate
      step :create
      step :assign_default_project

      private

      def validate(params)
        contract = UserCreateServiceContract.new.call(params)
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

      def assign_default_project(user)
        default_project_params = { title: 'New project' }
        ProjectRepository.create(default_project_params.merge({ user_id: user.id }))
        Success(user)
      end
    end
  end
end
