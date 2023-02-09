# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::ProjectsController' do
  let(:app) { Application.launch }
  let(:user_db_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_db_attributes) }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }
  let(:invalid_project_attributes) { { title: 'T', description: nil } }
  let(:user) { UserRepository.find(id: user_id) }

  it 'index' do
    ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id))
    project = ApplicationRepository::DB[:projects].where(project_attributes).first
    env = Rack::MockRequest.env_for('/api/v1/projects', 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)

    code, _, body = response
    content = JSON.parse(body.first)

    expect(code).to eq 200
    expect(content).to eq(
      {
        'data' => [{
          'id' => project[:id].to_s,
          'type' => 'project',
          'attributes' => {
            'title' => project[:title],
            'description' => project[:description]
          }
        }]
      }
    )
  end

  it 'create' do
    number_of_projects = ApplicationRepository::DB[:projects].count
    env = Rack::MockRequest.env_for(
      '/api/v1/projects',
      'REQUEST_METHOD' => 'POST',
      'CONTENT_TYPE' => 'application/json',
      input: project_attributes.to_json
    )
    login(env, user_id)
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
    login(env, user_id)
    response = app.call(env)

    code, = response
    expect(code).to eq 422
    expect(ApplicationRepository::DB[:projects].count).to eq(number_of_projects)
  end

  it 'update' do
    ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id))

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
    login(env, user_id)
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
    login(env, user_id)
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end

  it 'delete' do
    ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id))

    project = ApplicationRepository::DB[:projects].where(project_attributes).first

    env = Rack::MockRequest.env_for(
      "/api/v1/projects/#{project[:id]}",
      'REQUEST_METHOD' => 'DELETE'
    )
    login(env, user_id)
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
    login(env, user_id)
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end

  it 'show' do
    ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id))
    project = ApplicationRepository::DB[:projects].where(project_attributes).first
    env = Rack::MockRequest.env_for("/api/v1/projects/#{project[:id]}", 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)

    code, _, body = response
    content = JSON.parse(body.first)

    expect(code).to eq 200
    expect(content).to eq(
      {
        'data' => {
          'id' => project[:id].to_s,
          'type' => 'project',
          'attributes' => {
            'title' => project[:title],
            'description' => project[:description]
          }

        }
      }
    )
  end

  # it 'show with author' do
  #   ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id))
  #   project = ApplicationRepository::DB[:projects].where(project_attributes).first
  #   env = Rack::MockRequest.env_for("/api/v1/projects/#{project[:id]}?include=author", 'REQUEST_METHOD' => 'GET')
  #   login(env, user_id)
  #   response = app.call(env)
  #
  #   code, _, body = response
  #   content = JSON.parse(body.first)
  #
  #   expect(code).to eq 200
  #   expect(content).to eq(
  #     {
  #       'data' => {
  #         'id' => project[:id].to_s,
  #         'type' => 'project',
  #         'attributes' => {
  #           'title' => project[:title],
  #           'description' => project[:description]
  #         },
  #         'relationships' => {
  #           'author' => {
  #             'data' => {
  #               'id' => user_id.to_s,
  #               'type' => 'user'
  #             }
  #           }
  #         },
  #         'included' => [
  #           {
  #             'type' => 'user',
  #             'id' => user.id.to_s,
  #             'attributes' => {
  #               'email' => user.email
  #             }
  #           }
  #         ]
  #       }
  #     }
  #   )
  # end

  it 'failed to show with 404' do
    env = Rack::MockRequest.env_for('/api/v1/projects/100500', 'REQUEST_METHOD' => 'GET')
    login(env, user_id)
    response = app.call(env)

    code, = response
    expect(code).to eq 404
  end
end
