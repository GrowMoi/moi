class AddInactiveImageSuperEvent < ActiveRecord::Migration
  def change
    add_column :event_achievements, :inactive_image, :string
  end
end
