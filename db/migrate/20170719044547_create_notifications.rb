class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.integer :media_count, default: 0
      t.references :user, index: true, null: false
      t.timestamps null: false
    end
  end
end
