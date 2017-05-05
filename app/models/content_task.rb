# == Schema Information
#
# Table name: ContentTask
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
end