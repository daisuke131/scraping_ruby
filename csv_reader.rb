require 'csv'
require 'active_support/all'

HEADER_DEL_FLG = true
class CsvReader
  def self.Reader(csv_name)
    csv_data = CSV.read(csv_name, skip_blanks: true)
  rescue StandardError => e
    p '該当するcsvファイルはありません。'
    exit!
  end
end

while
  p '対象のCSVファイルを同フォルダ内に入れてください。'
  print '読み込むcsvの名前を入力してください:'
  input_name = gets
  next if input_name.blank?

  csv_data = CsvReader.Reader(input_name.chomp!)
  csv_data.shift if HEADER_DEL_FLG
  # 一応表示してるだけ
  csv_data.map { |val| p val.join(',') }
  break
end
