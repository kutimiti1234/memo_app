# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'

get '/' do
  @title = ''
  erb :index
end

get '/memos/*' do
  @memo_id = params['splat'].first
  erb :index
end
