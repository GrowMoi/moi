require "notification"

class OldNotificationMediaUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/notification/media/#{model.id}"
  end
end

class Content < ActiveRecord::Base
  mount_uploader :media, OldNotificationMediaUploader
end

class CreateNotificationMedia < ActiveRecord::Migration
  def up
    create_table :notification_media do |t|
      t.string :media
      t.references :notification, index: true, foreign_key: true
      t.timestamps null: false
    end
  end

  def down
    drop_table :notification_media
  end
end
