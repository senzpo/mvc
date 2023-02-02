# frozen_string_literal: true

module Api
  module V1
    module Projects
      # Show serializer for project entity
      class BaseSerializer < ApplicationSerializer
        attributes :title, :description
      end
    end
  end
end
