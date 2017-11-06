class CreateReadNotifications < ActiveRecord::Migration
  def change
    create_table :read_notifications do |t|
      t.references :user, index: true, null: false
      t.references :notifications, index: true, null: false
      t.timestamps null: false
    end
  end
end
