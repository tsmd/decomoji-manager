class CreateDecomojis < ActiveRecord::Migration[7.1]
  def change
    create_table :decomojis do |t|
      t.string :name
      t.string :yomi

      t.timestamps
    end
  end
end
