# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require './application'
require './spec/support/session_helper.rb'

RSpec.configure do |config|
  config.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(ApplicationRepository::DB, 'db/migrations')
  end

  config.around do |ex|
    ApplicationRepository::DB.transaction do
      ex.run
      ApplicationRepository::DB.rollback_on_exit
    end
  end

  config.include SessionHelper
end
