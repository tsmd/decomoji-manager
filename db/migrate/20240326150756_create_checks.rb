class CreateChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :checks do |t|
      t.string :name, null: false
      t.string :status, null: false, default: 'in_progress'

      t.timestamps
    end
  end
end
