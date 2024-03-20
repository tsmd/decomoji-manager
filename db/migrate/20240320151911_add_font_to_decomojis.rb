class AddFontToDecomojis < ActiveRecord::Migration[7.1]
  def change
    add_column :decomojis, :font, :string, default: 'sans-serif'
  end
end
