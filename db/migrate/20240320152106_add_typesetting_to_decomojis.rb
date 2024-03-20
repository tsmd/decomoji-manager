class AddTypesettingToDecomojis < ActiveRecord::Migration[7.1]
  def change
    add_column :decomojis, :typesetting, :string
  end
end
