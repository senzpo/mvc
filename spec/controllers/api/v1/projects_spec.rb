# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::ProjectsController' do
  let(:app) { Application.launch }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }
  let(:invalid_project_attributes) { { title: 'T', description: nil } }

  it 'index' do
    puts ">>>>>>>>>>> object_id #{object_id}"
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

  it 'update' do
    ApplicationRepository::DB[:projects].insert(project_attributes)

    project = ApplicationRepository::DB[:projects].where(project_attributes).first
    new_title = "updated #{project[:title]}"
    new_description = "updated #{project[:description]}"
    new_attributes = project.merge({ title: new_title, description: new_description })

    env = Rack::MockRequest.env_for(
      "/api/v1/projects/#{project[:id]}",
      'REQUEST_METHOD' => 'PATCH',
      'CONTENT_TYPE' => 'application/json',
      input: new_attributes.to_json
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 204

    updated_project = ApplicationRepository::DB[:projects].where(id: new_attributes[:id]).first
    expect(updated_project[:title]).to eq new_title
    expect(updated_project[:description]).to eq new_description
  end

  it 'failed to update with 404' do
    env = Rack::MockRequest.env_for(
      '/api/v1/projects/100500',
      'REQUEST_METHOD' => 'PATCH',
      'CONTENT_TYPE' => 'application/json',
      input: project_attributes.to_json
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end

  it 'delete' do
    ApplicationRepository::DB[:projects].insert(project_attributes)

    project = ApplicationRepository::DB[:projects].where(project_attributes).first

    env = Rack::MockRequest.env_for(
      "/api/v1/projects/#{project[:id]}",
      'REQUEST_METHOD' => 'DELETE'
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 204

    expect(ApplicationRepository::DB[:projects].where(id: project[:id]).first).to eq nil
  end

  it 'failed to delete with 404' do
    env = Rack::MockRequest.env_for(
      '/api/v1/projects/100500',
      'REQUEST_METHOD' => 'DELETE'
    )
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end

  it 'show' do
    ApplicationRepository::DB[:projects].insert(project_attributes)
    project = ApplicationRepository::DB[:projects].where(project_attributes).first
    env = Rack::MockRequest.env_for("/api/v1/projects/#{project[:id]}", 'REQUEST_METHOD' => 'GET')
    response = app.call(env)

    code, = response
    expect(code).to eq 200
  end

  it 'failed to show with 404' do
    env = Rack::MockRequest.env_for('/api/v1/projects/100500', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end
end
