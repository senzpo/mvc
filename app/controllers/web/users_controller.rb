# frozen_string_literal: true

module Web
  # Handler for users page
  class UsersController < ApplicationController
    def index
      users = ApplicationRepository::DB[:users].all

      render locals: { users: users }
    end

    def new
      render
    end

    def update
      user = ApplicationRepository::DB[:users].where(id: params[:id]).first
      params = user.merge(request_params)
      ApplicationRepository::DB[:users].where(id: params[:id]).update(params)

      head 302, headers: { 'location' => "/users/#{params[:id]}" }
    end

    def create
      ApplicationRepository::DB[:users].insert(request_params)

      head 302, headers: { 'location' => '/users' }
    end

    def edit
      user = ApplicationRepository::DB[:users].where(id: params[:id]).first

      render locals: { user: user }
    end

    def show
      user = ApplicationRepository::DB[:users].where(id: params[:id]).first

      render locals: { user: user }
    end
  end
end
