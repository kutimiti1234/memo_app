# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

get '/' do
  memos = Memo.new
  @memos = memos
  @show_memo_id = memos.getfirstmemoid
  erb :index
end

get '/memos/:memo_id' do
  status 200
  memos = Memo.new
  show_memo_id = params['memo_id']
  pass unless memos.exist?(show_memo_id)

  @memos = memos
  @show_memo_id = show_memo_id

  erb :index
end

post '/memos/' do
  status 201
  memos = Memo.new
  memos.add(title: params[:title], content: params[:content])
  redirect '/'
  erb :index
end

delete '/memos/:memo_id' do
  status 200
  memos = Memo.new
  show_memo_id = params['memo_id']
  pass unless memos.exist?(show_memo_id)
  pass if memos.length == 1

  memos.delete(show_memo_id)
  redirect '/'
end

delete '/memos/:memo_id' do
  status 400
  erb :alert
end

not_found do
  status 404
  '404 - Not Found'
end

# メモの読み書き、表示、削除用のクラス。
class Memo
  attr_accessor :memos

  def initialize
    @memos = CSV.read('./output/Sample.csv', headers: true)
  end

  def add(title:, content:)
    new_id = SecureRandom.uuid
    @memos << CSV::Row.new(%w[id title content], [new_id, title, content])
    File.write('./output/Sample.csv', @memos)
  end

  def update(id); end

  def delete(id)
    @memos = CSV::Table.new(@memos.reject { |row| row['id'] == id })
    File.write('./output/Sample.csv', @memos)
  end

  def showtitle(id)
    @memos.select { |row| row['id'] == id }.first['title']
  end

  def showcontent(id)
    @memos.select { |row| row['id'] == id }.first['content']
  end

  def getfirstmemoid
    @memos.first['id']
  end

  def exist?(id)
    !!@memos.select { |row| row['id'] == id }.first
  end

  def length
    @memos.length
  end
end
