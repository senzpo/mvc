# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::ErrorsController' do
  let(:app) do
    Rack::Builder.new do |builder|
      builder.use Rack::Session::Cookie, domain: 'localhost', path: '/', expire_after: 3600 * 24,
                                         secret: SecureRandom.hex(64)
      builder.run Application.new
    end
  end

  it 'index for unauthorized user' do
    env = Rack::MockRequest.env_for('/missed_route', 'REQUEST_METHOD' => 'GET')
    response = app.call(env)
    code, = response
    expect(code).to eq 404
  end
end
