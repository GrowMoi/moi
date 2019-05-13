class CreateUserEventAchievements < ActiveRecord::Migration
  def change
    create_table :user_event_achievements do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :event_achievement,
                   null: false,
                   index: true
      t.string :status, default: 'taken'
      t.timestamps null: false
    end
  end
end
