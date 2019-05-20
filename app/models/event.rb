# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  description    :string
#  image          :string
#  content_ids    :text             default([]), is an Array
#  duration       :integer          not null
#  kind           :string
#  user_level     :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  active         :boolean          default(TRUE)
#  inactive_image :string
#

class Event < ActiveRecord::Base
  has_many :user_events,
           dependent: :destroy

  mount_uploader :image, ContentMediaUploader
  mount_uploader :inactive_image, ContentMediaUploader
end
