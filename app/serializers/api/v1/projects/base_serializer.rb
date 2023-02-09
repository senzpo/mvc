# frozen_string_literal: true

module Api
  module V1
    module Projects
      # Show serializer for project entity
      class BaseSerializer < ApplicationSerializer
        attributes :title, :description

        has_one :author do |object|
          ApplicationSerializer.new(object.author).serialize
        end
      end
    end
  end
end
