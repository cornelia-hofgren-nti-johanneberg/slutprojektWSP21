require 'sinatra'
require 'slim'
require_relative './model.rb'

enable :sessions



get('/') do
    slim(:home)
end
