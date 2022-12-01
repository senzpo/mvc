# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::SessionsController' do
  let(:app) do
    Rack::Builder.new do |builder|
      builder.use Rack::Session::Cookie, domain: 'localhost', path: '/', expire_after: 3600 * 24,
                                         secret: SecureRandom.hex(64)
      builder.run Application.new
    end
  end
  let(:password) { 'awesome_pass' }
  let(:password_hash) { '$2a$12$IsIjIHptwtYatJU7UXHOzu5praukAbElPvkc3i5i/3wJGBCP/5xKq' }
  let(:salt) { '1960874c' }

  let(:user_db_attributes) do
    {
      email: 'example@example.com',
      password_hash: password_hash,
      salt: salt
    }
  end

  let(:user_attributes) do
    {
      email: 'example@example.com',
      password: password
    }
  end

  let(:failed_user_attributes) do
    {
      email: 'failed@example.com',
      password: password
    }
  end

  it 'create' do
    ApplicationRepository::DB[:users].insert(user_db_attributes)
    env = Rack::MockRequest.env_for(
      '/sessions',
      'REQUEST_METHOD' => 'POST',
      params: user_attributes
    )
    response = app.call(env)
    code, headers = response
    expect(code).to eq 302
    expect(headers['Location']).to eq('/')
  end

  it 'failed to create session' do
    ApplicationRepository::DB[:users].insert(user_db_attributes)
    env = Rack::MockRequest.env_for(
      '/sessions',
      'REQUEST_METHOD' => 'POST',
      params: failed_user_attributes
    )
    response = app.call(env)
    code, headers = response
    expect(code).to eq 302
    expect(headers['Location']).to eq('/login')
  end
end
