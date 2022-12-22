# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::ErrorsController' do
  let(:app) { Application.launch }

  it 'index for unauthorized user' do
    env = Rack::MockRequest.env_for('/missed_route', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)
    code, = response
    expect(code).to eq 404
  end
end
