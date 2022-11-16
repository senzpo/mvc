# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::ProjectsController' do
  let(:app) { Application.new }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }
  let(:invalid_project_attributes) { { title: 'T', description: nil } }

  it 'index' do
    env = Rack::MockRequest.env_for('/api/v1/projects', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)

    code, = response
    expect(code).to eq 200
  end

  it 'create' do
    number_of_projects = ApplicationRepository::DB[:projects].count
    env = Rack::MockRequest.env_for(
      '/api/v1/projects',
      'REQUEST_METHOD' => 'POST',
      'CONTENT_TYPE' => 'application/json',
      input: project_attributes.to_json
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 201
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects + 1)
  end

  it 'failed to create' do
    number_of_projects = ApplicationRepository::DB[:projects].count
    env = Rack::MockRequest.env_for(
      '/api/v1/projects',
      'REQUEST_METHOD' => 'POST',
      'CONTENT_TYPE' => 'application/json',
      input: invalid_project_attributes.to_json
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 422
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects)
  end
end
