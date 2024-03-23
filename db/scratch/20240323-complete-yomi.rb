# merged.csv の yomi 列を kunnrei 列から補完する

require 'csv'

include RomajiKanaConverter

ActiveRecord::Base.transaction do
  file_path = Rails.root.join('db', 'merged.csv')
  CSV.foreach(file_path, headers: true) do |row|
    yomi = to_kana_adjusted(row['kunnrei'], row['name'])
    decomoji = Decomoji.find_by(name: row['name'])
    decomoji.update!(yomi: yomi) if decomoji.yomi.blank?
  end
end
