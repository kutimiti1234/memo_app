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
  memos = Memo.new
  @memos = memos
  @show_memo_id = memos.first_memo_id
  erb :index
end

get '/memos/:memo_id' do
  status 200
  memos = Memo.new
  show_memo_id = params['memo_id']
  pass unless  memos.exist?(show_memo_id)
  @memos = memos
  @show_memo_id = show_memo_id

  erb :index
end

get '/memos/:memo_id/edit' do
  status 200
  memos = Memo.new
  show_memo_id = params['memo_id']
  pass if memos.blank?(show_memo_id)

  @memos = memos
  @show_memo_id = show_memo_id
  @editflg = true
  erb :index
end

post '/memos/' do
  status 201
  memos = Memo.new
  memos.add(title: params[:title], content: params[:content])
  redirect '/'
end

delete '/memos/:memo_id' do
  status 200
  memos = Memo.new
  show_memo_id = params['memo_id']
  pass if memos.blank?(show_memo_id) || memos.length == 1

  memos.delete(show_memo_id)
  redirect '/'
end

delete '/memos/:memo_id' do
  status 400
  erb :alert
end

patch '/memos/:memo_id' do
  status 200
  memos = Memo.new
  id = params['memo_id']
  pass if memos.blank?(id)

  memos.update(id: id, title: params['title'], content: params['content'])
  redirect '/'
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

  def first_memo_id
    @memos.first['id']
  end

  def length
    @memos.length
  end

  def showtitle(id)
    @memos.select { |row| row['id'] == id }.first['title']
  end

  def showcontent(id)
    @memos.select { |row| row['id'] == id }.first['content']
  end

  def write_csv
    File.write('./output/Sample.csv', @memos)
  end

  def add(title:, content:)
    new_id = SecureRandom.uuid
    @memos << CSV::Row.new(%w[id title content], [new_id, title, content])
    write_csv
  end

  def update(id:, title:, content:)
    row_index = @memos['id'].find_index(id)
    @memos[row_index]['title'] = title
    @memos[row_index]['content'] = content
    write_csv
  end

  def delete(id)
    @memos = CSV::Table.new(@memos.reject { |row| row['id'] == id })
    write_csv
  end

  def exist?(id)
    !@memos.select { |row| row['id'] == id }.empty?
  end

  def blank?(id)
    @memos.select { |row| row['id'] == id }.empty?
  end
end
