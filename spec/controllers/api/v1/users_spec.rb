# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::UsersController' do
  let(:app) { Application.launch }
  let(:user_db_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_attributes) { { email: 'some@example.com', password: 'secret' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_db_attributes) }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }

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
    ApplicationRepository::DB[:projects].insert(project_attributes.merge({ user_id: user_id }))
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", 'REQUEST_METHOD' => 'DELETE')
    login(env, user_id)
    response = app.call(env)

    code, = response
    expect(code).to eq 204
    expect(ApplicationRepository::DB[:users].where(id: user_id).count).to eq(0)
    expect(ApplicationRepository::DB[:projects].where(user_id: user_id).count).to eq(0)
  end
end
