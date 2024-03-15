class AddIndexToDecomojisName < ActiveRecord::Migration[7.1]
  def change
    add_index :decomojis, :name, unique: true
  end
end
