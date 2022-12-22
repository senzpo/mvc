# frozen_string_literal: true

require 'bundler'

Bundler.require

require './application'

task :default do
  puts 'Hello from default task!'
end

namespace :db do
  # http://sequel.jeremyevans.net/documentation.html
  desc 'Create database'
  task :create do
    SQLite3::Database.open(ApplicationRepository.db_config['db']['path'])
  end

  desc 'Drop database'
  task :drop do
    File.delete(ApplicationRepository.db_config['db']['path'])
  end

  desc 'Migrate database'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(ApplicationRepository::DB, 'db/migrations')
  end

  desc 'Rollback database'
  task :rollback do
    Sequel.extension :migration
    steps = ENV['STEPS'].to_i || 1
    Sequel::Migrator.run(ApplicationRepository::DB, 'db/migrations', relative: steps * -1)
  end
end

namespace :app do
  desc 'Run controllers test'
  task :console do
    require 'rubygems'
    require 'bundler'
    require 'securerandom'
    require 'irb'

    Bundler.require

    require './application'

    ARGV.clear
    IRB.start
  end
end

namespace :test do
  require 'rake'
  require 'rspec/core/rake_task'

  desc 'Run controllers test'
  task :controllers do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = 'spec/controllers/**/*_spec.rb'
    end
    Rake::Task['spec'].execute
  end
end
