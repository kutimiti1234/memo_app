# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require_relative 'lib/memo'
require_relative 'lib/conncector'
require 'yaml'

configure do
  db_config = YAML.load_file('database.yml')
  production_config = db_config['production']
  DatabaseConnector.connect(production_config)
  DatabaseConnector.create_table
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
  database = MemoDatabase.new(DatabaseConnector.conn)
  @memos = database.load_all_memos
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
  database = MemoDatabase.new(DatabaseConnector.conn)
  @memo = database.search_memo_by_id(params['memo_id'])
  pass if @memo.nil?
  @id = params['memo_id']
  @title = 'Show memo'

  status 200
  erb :show
end

get '/memos/:memo_id/edit' do
  database = MemoDatabase.new(DatabaseConnector.conn)
  @memo = database.search_memo_by_id(params['memo_id'])
  @id = params['memo_id']
  @title = 'Edit memo'
  pass unless @memo

  status 200
  erb :edit
end

post '/memos/' do
  database = MemoDatabase.new(DatabaseConnector.conn)
  database.add(title: params[:title], content: params[:content])

  redirect '/memos'
end

delete '/memos/:memo_id' do
  database = MemoDatabase.new(DatabaseConnector.conn)
  memo = database.search_memo_by_id(params['memo_id'])
  id = params['memo_id']
  pass if memo.nil?

  database.delete(id)
  redirect '/memos'
end

patch '/memos/:memo_id' do
  database = MemoDatabase.new(DatabaseConnector.conn)
  id = params['memo_id']

  database.update(id: id, title: params['title'], content: params['content'])
  redirect '/memos'
end

not_found do
  status 404
  '404 - Not Found'
end
