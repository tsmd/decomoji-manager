class UpdateForeignKeyConstraintsForDecomojis < ActiveRecord::Migration[7.1]
  def change
    # version_id と color_id の外部キー制約をオプショナルに設定
    remove_foreign_key :decomojis, :versions
    remove_foreign_key :decomojis, :colors

    add_foreign_key :decomojis, :versions, on_delete: :nullify
    add_foreign_key :decomojis, :colors, on_delete: :nullify
  end
end
