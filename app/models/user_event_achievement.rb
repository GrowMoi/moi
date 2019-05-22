# == Schema Information
#
# Table name: user_event_achievements
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  event_achievement_id :integer          not null
#  status               :string           default("taken")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class UserEventAchievement < ActiveRecord::Base

  STATUS = %w(
    taken
    expired
    completed
  ).freeze

  begin :relationships
    belongs_to :user
    belongs_to :event_achievement
  end

  begin :validations
    validates_uniqueness_of :user_id, :scope => :event_achievement_id
    validates :status, presence: true,
                    inclusion: {in: STATUS}
  end

  def super_event_is_valid_yet
    !self.event_achievement.is_expired && self.event_achievement.status == "taken"
  end
  
end
