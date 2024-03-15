class ChangeDecomojis < ActiveRecord::Migration[7.1]
  def change
    change_column_null :decomojis, :name, false
    change_column_null :decomojis, :yomi, false
  end
end
