class UsersController < ApplicationController
  def index
    @items = []
    render code: 201
  end

  def new
    render code: 302, headers: {'Location' => '/login'}, no_content: true
  end

  def show
    @id = params[:id]
    @tag_id = params[:tag_id]
    render code: 201
  end
end
