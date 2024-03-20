class AddColorRefToDecomojis < ActiveRecord::Migration[7.1]
  def change
    add_reference :decomojis, :color, null: true, foreign_key: true
  end
end
