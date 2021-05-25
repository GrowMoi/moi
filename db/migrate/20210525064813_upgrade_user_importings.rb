class UpgradeUserImportings < ActiveRecord::Migration
  def change
    change_column :user_importings, :list, :text
  end
end
