class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :integer
  end
end
