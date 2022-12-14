# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::UsersController' do
  let(:app) { Application.new }
  let(:user_db_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_attributes) { { email: 'some@example.com', password: 'secret' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_db_attributes) }

  it 'index' do
    env = Rack::MockRequest.env_for('/api/v1/users', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)

    code, = response
    expect(code).to eq 200
  end

  it 'update' do
    email = 'Some new email'
    attributes = { email: email }.to_json
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}",
                                    'REQUEST_METHOD' => 'PATCH',
                                    'CONTENT_TYPE' => 'application/json',
                                    input: attributes)
    response = app.call(env)

    code, = response
    expect(code).to eq 204
    expect(ApplicationRepository::DB[:users].where(id: user_id, email: email).count).to eq(1)
  end

  it 'show' do
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", 'REQUEST_METHOD' => 'GET')
    response = app.call(env)

    code, = response
    expect(code).to eq 200
  end

  it 'create' do
    number_of_users = ApplicationRepository::DB[:users].count
    number_of_projects = ApplicationRepository::DB[:projects].count
    env = Rack::MockRequest.env_for('/api/v1/users',
                                    'REQUEST_METHOD' => 'POST',
                                    'CONTENT_TYPE' => 'application/json',
                                    input: user_attributes.to_json)
    response = app.call(env)

    code, = response
    expect(code).to eq 204
    expect(ApplicationRepository::DB[:users].count).to eq(number_of_users + 1)
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects + 1)
  end

  it 'delete' do
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", 'REQUEST_METHOD' => 'DELETE')
    response = app.call(env)

    code, = response
    expect(code).to eq 204
    expect(ApplicationRepository::DB[:users].where(id: user_id).count).to eq(0)
  end
end
