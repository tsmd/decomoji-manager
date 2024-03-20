require 'csv'

# versions.csv のデータを使用して Version モデルにデータを登録する
file_path = Rails.root.join('db', 'versions.csv')
CSV.foreach(file_path, headers: true) do |row|
  Version.find_or_create_by(
    name: row['version'],
  )
end

# colors.csv のデータを使用して Color モデルにデータを登録する
file_path = Rails.root.join('db', 'colors.csv')
CSV.foreach(file_path, headers: true) do |row|
  Color.find_or_create_by(
    name: row['name'],
    hex: row['hex'],
  )
end

# IDのオフセットを計算する
first_color_id = Color.order(:id).first.id

ActiveRecord::Base.transaction do
  # merged.csv 及び　decomoji ディレクトリ内の png　データを使用して
  # Decomoji モデルにデータを登録する。pngデータはblobとして登録する
  file_path = Rails.root.join('db', 'merged.csv')
  CSV.foreach(file_path, headers: true) do |row|
    print row['name']

    decomoji = Decomoji.find_or_initialize_by(name: row['name'])
    version = Version.find_by(name: row['created'])
    color_id = row['color'].to_i + first_color_id # オフセットを考慮
    color = Color.find_by(id: color_id)
    typesetting = row['name'] == row['typesetting'] ? nil : row['typesetting']

    if decomoji.new_record? || decomoji.image.blank?
      file_path = Rails.root.join('db', 'decomoji', "#{row['name']}.png")
      image = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_path, 'rb'),
        filename: "#{row['name']}.png",
        content_type: 'image/png'
      )
    end
    
    decomoji.assign_attributes(
      yomi: row['kana'],
      version: version,
      typesetting: typesetting,
      font: row['font'].blank? ? 'sans-serif' : row['font'],
      color: color
    )

    # 画像がなければアップロード
    decomoji.image = image if decomoji.new_record? || decomoji.image.blank?
    
    decomoji.save!
  end
end
