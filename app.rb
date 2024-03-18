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

  status 200
  erb :index
end

get '/memos/new' do
  @title = 'New memo'
  erb :create
end

get '/memos/:memo_id' do
  database = MemoDatabase.new
  @memo = database.search_memo_by_id(params['memo_id'])
  pass if @memo.nil?
  @id = params['memo_id']
  @title = 'Show memo'

  status 200
  erb :show
end

get '/memos/:memo_id/edit' do
  database = MemoDatabase.new
  @memo = database.search_memo_by_id(params['memo_id'])
  @id = params['memo_id']
  @title = 'Edit memo'
  pass unless @memo

  status 200
  erb :edit
end

post '/memos/' do
  database = MemoDatabase.new
  database.add(title: params[:title], content: params[:content])

  redirect '/memos'
end

delete '/memos/:memo_id' do
  database = MemoDatabase.new
  memo = database.search_memo_by_id(params['memo_id'])
  id = params['memo_id']
  pass if memo.nil?

  database.delete(id)
  redirect '/memos'
end

patch '/memos/:memo_id' do
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
    unless File.exist?('./output/Sample.csv')
      File.write('./output/Sample.csv', <<~CSV)
        id,title,contetnt
      CSV
    end

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
