# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require_relative 'lib/memo'

configure do
  set :database, MemoDatabase.new
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = settings.database.load_all_memos
  @title = 'top'

  status 200
  erb :index
end

get '/memos/new' do
  @title = 'New memo'

  status 200
  erb :create
end

get '/memos/:memo_id' do
  @memo = settings.database.search_memo_by_id(params['memo_id'])
  pass if @memo.nil?
  @id = params['memo_id']
  @title = 'Show memo'

  status 200
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo = settings.database.search_memo_by_id(params['memo_id'])
  @id = params['memo_id']
  @title = 'Edit memo'
  pass unless @memo

  status 200
  erb :edit
end

post '/memos/' do
  settings.database.add(title: params[:title], content: params[:content])

  redirect '/memos'
end

delete '/memos/:memo_id' do
  memo = settings.database.search_memo_by_id(params['memo_id'])
  id = params['memo_id']
  pass if memo.nil?

  settings.database.delete(id)
  redirect '/memos'
end

patch '/memos/:memo_id' do
  id = params['memo_id']

  settings.database.update(id: id, title: params['title'], content: params['content'])
  redirect '/memos'
end

not_found do
  status 404
  '404 - Not Found'
end
