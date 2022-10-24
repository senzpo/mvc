module Web
  class UsersController < ApplicationController
    def index
      @items = []
      render
    end

    def new
      render
    end

    def create
      request.params
      render head: 302, headers: {'Location' => '/users'}
    end

    def show
      @id = params[:id]

      render
    end
  end
end
