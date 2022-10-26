require 'bundler'

Bundler.require

require './application'

task :default do
  puts 'Hello from default task!'
end

namespace :db do
  # http://sequel.jeremyevans.net/documentation.html
  desc "Create database"
  task :create do
    SQLite3::Database.open(Application.db_config['development']['db']['name'])
  end

  desc "Drop database"
  task :drop do
    File.delete(Application.db_config['development']['db']['name'])
  end

  desc "Migrate database"
  task :migrate do
    puts 'Hello from some task'
  end

  desc "Rollback database"
  task :rollback do
    puts 'Hello from some task'
  end
end
