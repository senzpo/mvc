# frozen_string_literal: true

module Api
  module V1
    module Projects
      class ShowSerializer < ApplicationSerializer
        # type 'Projects'

        def id
          'UUID'
        end

        attributes :id, :title, :description
      end
    end
  end
end
