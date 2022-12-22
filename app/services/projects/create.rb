# frozen_string_literal: true

# Web interface
module Services
  # Users services namespace
  module Projects
    # Persist user with default project
    class Create
      include Dry::Transaction

      step :validate
      step :create

      private

      def validate(params)
        contract = ProjectContract.new.call(params)
        if contract.success?
          Success(contract)
        else
          Failure(contract)
        end
      end

      def create(contract)
        project_params = contract.to_h.slice(:title, :description, :user_id)
        project = ProjectRepository.create(project_params)
        Success(project)
      end
    end
  end
end
