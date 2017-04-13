class User < ActiveRecord::Base
  module UserMediaSeen

    def media_seen(media_id)
      user_media = UserSeenImage.where(user_id: self.id, content_media_id: media_id)
      unless user_media.any?
        user_media = UserSeenImage.new(user_id: self.id, content_media_id: media_id)
        user_media.save
      end
      user_media
    end
  end
end
