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
    validates :status, presence: true,
                    inclusion: {in: STATUS}
  end
end
