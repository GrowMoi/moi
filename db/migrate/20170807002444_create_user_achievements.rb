class CreateUserAchievements < ActiveRecord::Migration
  def change
    create_table :user_achievements do |t|
      t.references :user, index: true, null: false
      t.references :achievement, index: true, null: false
      t.timestamps null: false
    end
  end
end
