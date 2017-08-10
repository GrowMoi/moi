# == Schema Information
#
# Table name: content_favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentFavorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
end
