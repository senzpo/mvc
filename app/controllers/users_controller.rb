class UsersController < ApplicationController
  def index
    @items = []
    render code: 200
  end

  def new
    render head: 302, headers: {'Location' => '/login'}
  end

  def show
    @id = params[:id]
    @tag_id = params[:tag_id]
    render code: 200
  end
end
