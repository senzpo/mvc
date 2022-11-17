class SessionsController < ApplicationController
  def new

  end

  def create
    user = UserRepository.all(email: request_params[:email])
    tested_password = BCrypt::Password.new(user.salt + request_params[:password])
    tested_password == user.password_hash
    head 200
  end
end
