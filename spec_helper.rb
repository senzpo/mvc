require 'rubygems'
require 'bundler'
require 'rake'

Bundler.require

require './application'

RSpec.configure do |config|
  config.before(:all) do
    `rake db:create`
    `rake db:migrate`
  end

  config.after(:all) do
    `rake db:drop`
  end
end
