# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'securerandom'

get '/' do
  @memos = Memo.new
  erb :index
end

get '/memos/:memo_id' do
  status 200
  @memos = Memo.new
  @show_memo_id = params['memo_id']
  erb :index
end

post '/memos/' do
  status 201
  @memos = Memo.new
  @memos.add(params[:title], params[:content])
  erb :index
end

# メモの読み書き、表示、削除用のクラス。
class Memo
  attr_accessor :memos

  def initialize
    @memos = CSV.read('./output/Sample.csv', headers: true)
  end

  def add(title, content)
    new_id = SecureRandom.uuid
    @memos << CSV::Row.new(%w[id title content], [new_id, title, content])
    File.write('./output/Sample.csv', @memos)
  end

  def update(id); end

  def delete(id); end

  def showtitle(id)
    id ||= @memos.first['id']
    memos.select { |row| row['id'] == id }.first['title']
  end

  def showcontent(id)
    id ||= @memos.first['id']
    memos.select { |row| row['id'] == id }.first['content']
  end
end
