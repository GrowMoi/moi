class AddImageTreeAppColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :tree_image_app, :string
  end
end
