class ChangeDecomojisYomiToBeNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :decomojis, :yomi, true
  end
end
