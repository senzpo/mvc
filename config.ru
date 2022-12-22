# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'securerandom'

Bundler.require

require './application'

use Rack::Reloader, 0
run Application.launch
