# frozen_string_literal: true

require 'pg'

# メモの読み書き、表示、削除用のクラス。
class MemoDatabase
  def initialize
    @conn = PG.connect(dbname: 'memodb')
    @conn.exec('CREATE TABLE IF NOT EXISTS public.memo_t(id uuid NOT NULL DEFAULT gen_random_uuid()
      ,title character varying COLLATE pg_catalog."default"
      ,content character varying COLLATE pg_catalog."default",CONSTRAINT uuid_table_pkey PRIMARY KEY (id))')
  end

  def load_all_memos
    @conn.exec_params('SELECT * FROM memo_t').to_a
  end

  def search_memo_by_id(id)
    @conn.exec_params('SELECT * FROM memo_t WHERE id = $1', [id]).to_a.first
  end

  def add(title:, content:)
    @conn.exec('INSERT INTO memo_t(title,content) VALUES($1,$2)', [title, content])
  end

  def update(id:, title:, content:)
    @conn.exec('UPDATE memo_t SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete(id)
    @conn.exec('DELETE FROM memo_t where id = $1', [id])
  end
end
