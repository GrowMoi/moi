class User < ActiveRecord::Base
  module UserMediaSeen

    def media_seen(params)
      userMedia = UserSeenImage.where(user_id: id, content_media_id: params["media_id"])
      if userMedia.empty?
        userMedia = UserSeenImage.new(user_id: id, content_media_id: params["media_id"])
        userMedia.save
      else
        userMedia
      end
    end
  end
end
