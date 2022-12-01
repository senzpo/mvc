# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'securerandom'

Bundler.require

require './application'

use Rack::Reloader, 0
use Rack::Session::Cookie, domain: 'localhost', path: '/', expire_after: 3600 * 24, secret: SecureRandom.hex(64)
run Application.new
