# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::ProjectsController' do
  let(:app) { Application.launch }

  it 'index for unauthorized user' do
    env = Rack::MockRequest.env_for('/projects', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)
    code, headers = response
    expect(code).to eq 302
    expect(headers['Location']).to eq('/login')
  end
end
