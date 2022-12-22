# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::ProjectsController' do
  let(:app) { Application.launch }
  let(:user_db_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_db_attributes) }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }
  let(:project_id) { ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id)) }

  it 'index for unauthorized user' do
    env = Rack::MockRequest.env_for('/projects', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)
    code, headers = response
    expect(code).to eq 302
    expect(headers['Location']).to eq('/login')
  end

  it 'new' do
    env = Rack::MockRequest.env_for('/projects/new', 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)
    code, = response
    expect(code).to eq 200
  end

  it 'index' do
    env = Rack::MockRequest.env_for('/projects', 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)
    code, = response
    expect(code).to eq 200
  end

  it 'show' do
    env = Rack::MockRequest.env_for("/projects/#{project_id}", 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)
    code, = response
    expect(code).to eq 200
  end

  it 'create' do
    number_of_projects = ApplicationRepository::DB[:projects].count
    env = Rack::MockRequest.env_for(
      '/projects',
      'REQUEST_METHOD' => 'POST',
      params: project_attributes
    )
    login(env, user_id)
    response = app.call(env)
    code, headers = response
    expect(code).to eq 303
    expect(headers['Location']).to eq('/projects')
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects + 1)
  end
end
