class CreateDecomojiChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :decomoji_checks do |t|
      t.integer :decomoji_id, null: false
      t.integer :check_id, null: false
      t.string :status, null: false, default: 'unchecked'
      t.timestamps

      t.index :decomoji_id
      t.index :check_id
      t.foreign_key :decomojis, column: :decomoji_id
      t.foreign_key :checks, column: :check_id
    end
  end
end
