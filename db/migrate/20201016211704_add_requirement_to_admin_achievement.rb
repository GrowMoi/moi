class AddRequirementToAdminAchievement < ActiveRecord::Migration
  def change
    add_column :admin_achievements, :requirement, :string
  end
end
