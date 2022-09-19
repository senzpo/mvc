require 'rubygems'
require 'bundler'

Bundler.require

require './application'

use Rack::Reloader

run Application.new
