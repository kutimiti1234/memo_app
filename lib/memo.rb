# メモの読み書き、表示、削除用のクラス。
class MemoDatabase
  attr_accessor :memos

  OUTPUT_PATH = './output/'
  CSV_PATH = './output/Sample.csv'

  def initialize
    unless File.exist?(CSV_PATH)
      Dir.mkdir('output', 0o755) unless File.exist?(OUTPUT_PATH)
      File.write(CSV_PATH, <<~CSV)
        id,title,contetnt
      CSV
    end

    @memos = CSV.read(CSV_PATH, headers: true)
  end

  def load_all_memos
    @memos
  end

  def search_memo_by_id(id)
    @memos.detect { |row| row['id'] == id }
  end

  def write
    File.write(CSV_PATH, @memos)
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
