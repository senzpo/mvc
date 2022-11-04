require 'spec_helper'

RSpec.describe 'Api::V1::UsersController' do
  let(:app) { Application.new }
  let(:user_attributes) { {name: 'Test', email: 'some@example.com', password: 'secret'} }
  let(:user_id) { Application.db[:users].insert(user_attributes) }

  it 'index' do
    env = Rack::MockRequest.env_for("/api/v1/users", "REQUEST_METHOD" => "GET")
    response = app.call(env)

    code, _, _ = response
    expect(code).to eq 200
  end

  it 'update' do
    name = 'Some new name'
    attributes = {name: name}.to_json
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", "REQUEST_METHOD" => "PATCH", "CONTENT_TYPE" => "application/json", input: attributes)
    response = app.call(env)

    code, _, _ = response
    expect(code).to eq 204
    expect(Application.db[:users].where(id: user_id, name: name).count).to eq(1)
  end

  it 'show' do
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", "REQUEST_METHOD" => "GET")
    response = app.call(env)

    code, _, _ = response
    expect(code).to eq 200
  end

  it 'create' do
    number_of_users = Application.db[:users].count
    env = Rack::MockRequest.env_for('/api/v1/users', "REQUEST_METHOD" => "POST", "CONTENT_TYPE" => "application/json", input: user_attributes.to_json)
    response = app.call(env)

    code, _, _ = response
    expect(code).to eq 204
    expect(Application.db[:users].count).to eq(number_of_users + 1)
  end

  it 'delete' do
    env = Rack::MockRequest.env_for("/api/v1/users/#{user_id}", "REQUEST_METHOD" => "DELETE")
    response = app.call(env)

    code, _, _ = response
    expect(code).to eq 204
    expect(Application.db[:users].where(id: user_id).count).to eq(0)
  end
end
