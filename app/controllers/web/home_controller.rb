# frozen_string_literal: true

module Web
  # Handler for start page
  class HomeController < ApplicationController
    def index
      binding.pry
      render
    end

    def signup
      render
    end
  end
end
