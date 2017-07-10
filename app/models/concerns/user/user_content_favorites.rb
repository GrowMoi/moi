class User < ActiveRecord::Base
  module UserContentFavorites

    def create_content_favorite(content_id)
      content_favorite = ContentFavorite.where(user_id: self.id, content_id: content_id)

      if content_favorite.empty?
        content_favorite = ContentFavorite.new(user_id: self.id, content_id: content_id)
        content_favorite.save
        false
      else
        true
      end

    end
  end
end
