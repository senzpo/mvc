# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Web::SessionsController' do
  let(:app) { Application.new }
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

  xit 'create' do
    ApplicationRepository::DB[:users].insert(user_db_attributes)
    env = Rack::MockRequest.env_for(
      '/sessions',
      'REQUEST_METHOD' => 'POST',
      params: user_attributes
    )
    response = app.call(env)
    expect(response).to be_truthy
  end
end
