class AddInactiveImageToAdminAchievements < ActiveRecord::Migration
  def change
    add_column :admin_achievements, :inactive_image, :string
  end
end
