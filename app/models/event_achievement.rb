# == Schema Information
#
# Table name: event_achievements
#
#  id                   :integer          not null, primary key
#  user_achievement_ids :integer          default([]), is an Array
#  title                :string           not null
#  start_date           :datetime         not null
#  end_date             :datetime         not null
#  image                :string
#  message              :text
#  new_users            :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :string
#

class EventAchievement < ActiveRecord::Base

  mount_uploader :image, ContentMediaUploader


  begin :relationships
    has_many :user_event_achievements,
              dependent: :destroy
  end


  def is_expired
    self.start_date < Time.now && self.end_date > Time.now
  end

end
