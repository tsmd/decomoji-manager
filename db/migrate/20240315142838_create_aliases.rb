class CreateAliases < ActiveRecord::Migration[7.1]
  def change
    create_table :aliases do |t|
      t.string :name, null: false
      t.references :decomoji, null: false, foreign_key: true

      t.timestamps
    end
  end
end
