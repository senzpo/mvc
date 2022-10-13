require 'rubygems'
require 'bundler'

Bundler.require

require './application'

use Rack::Reloader

run Application.new do
    get '/users' do
        'UsersController@index'
    end

    post '/users' do
        'UsersController@new'
    end
    
    get '/users/:id' do
        'UsersController@show'
    end
end
