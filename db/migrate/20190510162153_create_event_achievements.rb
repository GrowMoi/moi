class CreateEventAchievements < ActiveRecord::Migration
  def change
    create_table :event_achievements do |t|
      t.integer :user_achievement_ids, array: true, default: []
      t.string :name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :image
      t.text :message
      t.boolean :new_users, default: true
      t.timestamps null: false
    end
  end
end
