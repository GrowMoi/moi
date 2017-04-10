class User < ActiveRecord::Base
  module UserMediaSeen

    def media_seen(media_id)
      userMedia = UserSeenImage.where(user_id: id, content_media_id: media_id)
      if userMedia.empty?
        userMedia = UserSeenImage.new(user_id: id, content_media_id: media_id)
        userMedia.save
      else
        userMedia
      end
    end
  end
end
