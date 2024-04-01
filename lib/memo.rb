# frozen_string_literal: true

require 'pg'
require 'yaml'

# メモの読み書き、表示、削除用のクラス。
class MemoDatabase
  def initialize(connection)
    @conn = connection
  end

  def load_all_memos
    @conn.exec_params('SELECT * FROM memo_t').to_a
  end

  def search_memo_by_id(id)
    @conn.exec_params('SELECT * FROM memo_t WHERE id = $1', [id]).to_a.first
  end

  def add(title:, content:)
    @conn.exec_params('INSERT INTO memo_t(title,content) VALUES($1,$2)', [title, content])
  end

  def update(id:, title:, content:)
    @conn.exec_params('UPDATE memo_t SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete(id)
    @conn.exec_params('DELETE FROM memo_t where id = $1', [id])
  end
end
