# データベース接続を管理するクラス
class DatabaseConnector
  class << self
    attr_reader :conn
  end

  def self.create_table
    @conn.exec('CREATE TABLE IF NOT EXISTS public.memo_t(id uuid NOT NULL DEFAULT gen_random_uuid()
      ,title character varying COLLATE pg_catalog."default"
      ,content character varying COLLATE pg_catalog."default",CONSTRAINT uuid_table_pkey PRIMARY KEY (id))')
  end

  def self.connect(db_config)
    @conn = PG.connect(db_config)
  end

  def self.close
    @conn.close
  end
end
