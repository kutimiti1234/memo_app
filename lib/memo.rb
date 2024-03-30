# frozen_string_literal: true

require 'pg'
require 'yaml'
# メモの読み書き、表示、削除用のクラス。
class MemoDatabase
  def initialize
    db_config = YAML.load_file('database.yml')
    production_config = db_config['production']
    @conn = PG.connect(production_config)
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
    @conn.exec_params('INSERT INTO memo_t(title,content) VALUES($1,$2)', [title, content])
  end

  def update(id:, title:, content:)
    @conn.exec_params('UPDATE memo_t SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete(id)
    @conn.exec_params('DELETE FROM memo_t where id = $1', [id])
  end
end
