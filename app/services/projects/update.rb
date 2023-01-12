# frozen_string_literal: true

# Web interface
module Services
  # Projects services namespace
  module Projects
    # Update project
    class Update
      include Dry::Transaction

      step :validate
      step :update

      private

      def validate(params)
        contract = ProjectContract.new.call(params)
        if contract.success?
          Success(contract)
        else
          Failure(contract)
        end
      end

      def update(contract, project:)
        project_params = contract.to_h.slice(:title, :description, :user_id)
        project = ProjectRepository.update(project.id, project_params)
        Success(project)
      end
    end
  end
end
