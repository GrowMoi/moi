class AddDescriptionToSuperEvent < ActiveRecord::Migration
  def change
    add_column :event_achievements, :description, :string
  end
end
