# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require './application'

RSpec.configure do |config|
  config.before(:suite) do
    `rake db:create`
    `rake db:migrate`
  end

  config.after(:suite) do
    `rake db:drop`
  end

  config.around(:example) do |ex|
    ApplicationRepository::DB.transaction do
      ex.run
      ApplicationRepository::DB.rollback_on_exit
    end
  end
end
