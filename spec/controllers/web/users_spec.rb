# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::UsersController' do
  let(:app) { Application.new }
  let(:password) { 'awesome_pass' }

  let(:user_attributes) { {
    email: 'example@example.com',
    password: password,
    password_confirmation: password
  } }

  let(:invalid_user_attributes) { {
    email: 'example@example.com',
    password: password,
    password_confirmation: "_#{password}"
  } }

  it 'create' do
    number_of_users = ApplicationRepository::DB[:users].count
    env = Rack::MockRequest.env_for(
      '/users',
      'REQUEST_METHOD' => 'POST',
      params: user_attributes
    )
    response = app.call(env)

    code, headers = response
    expect(code).to eq 303
    expect(headers['location']).to eq '/'
    expect(ApplicationRepository::DB[:users].count).to eq(number_of_users + 1)
  end

  it 'failed to create' do
    number_of_users = ApplicationRepository::DB[:users].count
    env = Rack::MockRequest.env_for(
      '/users',
      'REQUEST_METHOD' => 'POST',
      params: invalid_user_attributes
    )
    response = app.call(env)

    code, headers = response
    expect(code).to eq 200
    expect(ApplicationRepository::DB[:users].count).to eq(number_of_users)
  end
end
