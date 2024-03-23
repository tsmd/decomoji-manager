# merged.csv の yomi 列を補完した時にあやしかった行を抽出する

require 'csv'

include RomajiKanaConverter

ActiveRecord::Base.transaction do
  file_path = Rails.root.join('db', 'merged.csv')
  CSV.foreach(file_path, headers: true) do |row|
    kunnrei = row['kunnrei']
    original = row['name']
    original = NKF.nkf('-w -W -Z', original).downcase
    original_parts = original.scan(/[a-zA-Z!?]+/)

    # original_partsのいずれかがkunnreiに2度以上登場する場合は要注意として出力する
    original_parts.each do |part|
      if kunnrei.scan(part).length >= 2
        puts "#{row['name']}, #{row['kunnrei']}"
        break
      end
    end
  end
end
