class AddVersionToDecomojis < ActiveRecord::Migration[7.1]
  def change
    add_reference :decomojis, :version, foreign_key: true
  end
end
