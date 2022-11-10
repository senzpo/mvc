# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require './application'

use Rack::Reloader, 0

run Application.new
