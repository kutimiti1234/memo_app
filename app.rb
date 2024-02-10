require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/reference' do
  @title = 'タイトル'
  @content = 'コンテント'
  erb :index
end
