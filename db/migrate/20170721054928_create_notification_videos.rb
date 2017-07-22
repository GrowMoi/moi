class CreateNotificationVideos < ActiveRecord::Migration

  def up
    create_table :notification_videos do |t|
      t.references :notification,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :url, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :notification_videos
  end
end
