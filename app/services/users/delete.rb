# frozen_string_literal: true

# Web interface
module Services
  module Users
    # Delete user with assets
    class Delete
      include Dry::Transaction

      step :validate
      step :load
      step :delete_assigned_projects
      step :delete

      private

      def validate(params)
        contract = UserDeleteServiceContract.new.call(params)
        if contract.success?
          Success(contract.to_h)
        else
          Failure(contract.to_h)
        end
      end

      def load(params)
        user = UserRepository.all(params).first
        if user
          Success(user)
        else
          Failure(user)
        end
      end

      def delete_assigned_projects(user)
        projects = ProjectRepository.all({ user_id: user.id })
        projects.each do |project|
          Services::Projects::Delete.new.call(project)
        end
        Success(user)
      end

      def delete(user)
        result = UserRepository.delete(user.id)
        if result
          Success(user)
        else
          Failure(user)
        end
      end
    end
  end
end
