# frozen_string_literal: true

module Web
  # Handler for errors
  class ErrorsController < Web::ApplicationController
    def _404
      render code: 404
    end
  end
end
