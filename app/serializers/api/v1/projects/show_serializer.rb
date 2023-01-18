# frozen_string_literal: true

module Api
  module V1
    module Projects
      # Show serializer for project entity
      class ShowSerializer < ApplicationSerializer
        type 'projects'

        def id
          SecureRandom.uuid
        end

        attributes :title, :description
      end
    end
  end
end
