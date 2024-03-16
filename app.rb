# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  database = MemoDatabase.new
  @memos = database.load_all_memos
  @title = 'top'
  erb :index
end

get '/memos/new' do
  @title = 'New memo'
  erb :create
end

get '/memos/:memo_id' do
  status 200
  database = MemoDatabase.new
  @memo = database.search_memo_by_id(params['memo_id'])
  @id = params['memo_id']
  @title = 'Show memo'

  erb :show
end

get '/memos/:memo_id/edit' do
  status 200
  database = MemoDatabase.new
  @memo = database.search_memo_by_id(params['memo_id'])
  @id = params['memo_id']
  @title = 'Edit memo'
  pass unless @memo

  erb :edit
end

post '/memos/' do
  status 201
  database = MemoDatabase.new
  database.add(title: params[:title], content: params[:content])
  redirect '/memos'
end

delete '/memos/:memo_id' do
  status 200
  database = MemoDatabase.new
  memo = database.search_memo_by_id(params['memo_id'])
  memos = database.load_all_memos
  id = params['memo_id']
  pass if memo.nil? || memos.length == 1

  database.delete(id)
  redirect '/memos'
end

delete '/memos/:memo_id' do
  status 405
  erb :alert
end

patch '/memos/:memo_id' do
  status 200
  database = MemoDatabase.new
  id = params['memo_id']

  database.update(id: id, title: params['title'], content: params['content'])
  redirect '/memos'
end

not_found do
  status 404
  '404 - Not Found'
end

# メモの読み書き、表示、削除用のクラス。
class MemoDatabase
  attr_accessor :memos

  def initialize
    @memos = CSV.read('./output/Sample.csv', headers: true)
  end

  def load_all_memos
    @memos
  end

  def search_memo_by_id(id)
    @memos.select { |row| row['id'] == id }.first
  end

  def write
    File.write('./output/Sample.csv', @memos)
  end

  def add(title:, content:)
    new_id = SecureRandom.uuid
    @memos << CSV::Row.new(%w[id title content], [new_id, title, content])
    write
  end

  def update(id:, title:, content:)
    row_index = @memos['id'].find_index(id)
    @memos[row_index]['title'] = title
    @memos[row_index]['content'] = content
    write
  end

  def delete(id)
    @memos = CSV::Table.new(@memos.reject { |row| row['id'] == id })
    write
  end
end
