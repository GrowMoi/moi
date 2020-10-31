class UpdateImportingUsers < ActiveRecord::Migration
  def change
    add_column :user_importings, :list, :string
    add_column :user_importings, :file_name, :string
  end
end
