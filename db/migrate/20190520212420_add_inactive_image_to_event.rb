class AddInactiveImageToEvent < ActiveRecord::Migration
  def change
    add_column :events, :inactive_image, :string
  end
end
