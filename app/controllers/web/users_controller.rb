module Web
  class UsersController < ApplicationController
    def index
      users = Application.db[:users].all

      render locals: {users: users}
    end

    def new
      render
    end

    def update
      user = Application.db[:users].where(id: params[:id]).first
      params = user.merge(request_params)
      Application.db[:users].where(id: params[:id]).update(params)

      render head: 302, headers: {'location' => "/users/#{params[:id]}"}
    end

    def create
      Application.db[:users].insert(request_params)

      render head: 302, headers: {'location' => '/users'}
    end

    def edit
      user = Application.db[:users].where(id: params[:id]).first

      render locals: {user: user}
    end

    def show
      user = Application.db[:users].where(id: params[:id]).first

      render locals: {user: user}
    end
  end
end
