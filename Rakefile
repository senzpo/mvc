require 'bundler'

Bundler.require

require './application'

task :default do
  puts 'Hello from default task!'
end

namespace :some_namespace do
  desc "Some task"
  task :some_task do
    puts 'Hello from some task'
  end
end