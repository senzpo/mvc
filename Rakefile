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
    Sequel.extension :migration
    Sequel::Migrator.run(Application.db, "db/migrations")
  end

  desc "Rollback database"
  task :rollback do
    Sequel.extension :migration
    steps = ENV['STEPS'].to_i || 1
    Sequel::Migrator.run(Application.db, "db/migrations", relative: steps * (-1))
  end
end
