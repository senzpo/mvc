# frozen_string_literal: true

# Web interface
module Services
  module Projects
    # Delete user with assets
    class Delete
      include Dry::Transaction

      step :delete

      private

      def delete(project)
        ProjectRepository.delete(project.id)
        Success(project)
      end
    end
  end
end
