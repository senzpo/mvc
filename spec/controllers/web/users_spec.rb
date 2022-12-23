# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::UsersController' do
  let(:app) { Application.launch }
  let(:password) { 'awesome_pass' }
  let(:user_db_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_db_attributes) }
  let(:user_attributes) do
    {
      email: 'example@example.com',
      password: password,
      password_confirmation: password
    }
  end

  let(:invalid_user_attributes) do
    {
      email: 'example@example.com',
      password: password,
      password_confirmation: "_#{password}"
    }
  end

  it 'create' do
    number_of_users = ApplicationRepository::DB[:users].count
    number_of_projects = ApplicationRepository::DB[:projects].count
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
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects + 1)
  end

  it 'failed to create' do
    number_of_users = ApplicationRepository::DB[:users].count
    env = Rack::MockRequest.env_for(
      '/users',
      'REQUEST_METHOD' => 'POST',
      params: invalid_user_attributes
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 200
    expect(ApplicationRepository::DB[:users].count).to eq(number_of_users)
  end

  it 'destroy' do
    env = Rack::MockRequest.env_for('/users/delete', 'REQUEST_METHOD' => 'POST')
    login(env, user_id)
    response = app.call(env)

    code, headers = response
    expect(code).to eq 303
    expect(headers['Location']).to eq '/'
    expect(ApplicationRepository::DB[:users].where(id: user_id).count).to eq(0)
  end
end
