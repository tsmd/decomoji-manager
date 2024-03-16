class CreateDecomojiTags < ActiveRecord::Migration[7.1]
  def change
    create_table :decomoji_tags do |t|
      t.references :decomoji, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
