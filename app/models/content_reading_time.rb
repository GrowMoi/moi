# == Schema Information
#
# Table name: content_reading_times
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  time       :float            not null
#  created_at :datetime         not null
#

class ContentReadingTime < ActiveRecord::Base
  belongs_to :content
  belongs_to :user
end
