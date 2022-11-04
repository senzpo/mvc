# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::ProjectsController' do
  let(:app) { Application.new }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }

  it 'create' do
    Application.db[:users].insert(name: 'Test', email: 'some@example.com', password: 'secret')
    number_of_projects = Application.db[:users].count
    env = Rack::MockRequest.env_for('/api/v1/projects', 'REQUEST_METHOD' => 'POST',
                                                        'CONTENT_TYPE' => 'application/json', input: project_attributes.to_json)
    response = app.call(env)

    code, = response
    expect(code).to eq 204
    expect(Application.db[:users].count).to eq(number_of_projects + 1)
  end
end
