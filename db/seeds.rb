require 'csv'

ActiveRecord::Base.transaction do
  # versions.csv のデータを使用して Version モデルにデータを登録する
  file_path = Rails.root.join('db', 'versions.csv')
  CSV.foreach(file_path, headers: true) do |row|
    Version.find_or_create_by(
      name: row['version'],
    )
  end

  # merged.csv 及び　decomoji ディレクトリ内の png　データを使用して
  # Decomoji モデルにデータを登録する。pngデータはblobとして登録する
  file_path = Rails.root.join('db', 'merged.csv')
  CSV.foreach(file_path, headers: true) do |row|
    print row['name']
    next if Decomoji.find_by(name: row['name'])

    file_path = Rails.root.join('db', 'decomoji', "#{row['name']}.png")
    version = Version.find_by(name: row['created'])
    image = ActiveStorage::Blob.create_and_upload!(
      io: File.open(file_path, 'rb'),
      filename: "#{row['name']}.png",
      content_type: 'image/png'
    )
    decomoji = Decomoji.create(
      name: row['name'],
      yomi: row['kana'],
      version: version,
      image: image,
    )
  end
end
