class CreateUserAdminAchievements < ActiveRecord::Migration
  def change
    create_table :user_admin_achievements do |t|
      t.references :user, index: true, null: false
      t.references :admin_achievement, index: true, null: false
      t.boolean :active, default: false
      t.timestamps null: false
    end
  end
end
