# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

get '/' do
  @title = ''
  erb :index
end

post '/memos/' do
  status 201
  memos = CSV.read('./output/Sample.csv', headers: true)
  new_id = SecureRandom.uuid
  memos << CSV::Row.new(%w[id title content], [new_id, params['title'], params['content']])
  File.write('./output/Sample.csv', memos)
  erb :index
end

get '/memos/:memo_id' do
  status 200
  @memo_id = params['memo_id']
  erb :index
end
