class AddParamsNotificationSuperEvent < ActiveRecord::Migration
  def change
    add_column :event_achievements, :title_message, :string
    add_column :event_achievements, :image_message, :string
    add_column :event_achievements, :video_message, :string
  end
end
