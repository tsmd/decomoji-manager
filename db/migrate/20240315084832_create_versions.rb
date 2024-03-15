class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions do |t|
      t.text :name, null: false

      t.timestamps
    end

    add_index :versions, :name, unique: true
  end
end
