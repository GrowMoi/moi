class ContentMedia < ActiveRecord::Base
  belongs_to :content

  mount_uploader :media, ContentMediaUploader
end
