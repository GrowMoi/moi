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
    validate :only_for_new_users, on: :create
  end

  def super_event_is_valid_yet
    !self.event_achievement.is_expired && self.status == "taken"
  end

  private

  def only_for_new_users
    if self.event_achievement.new_users && self.user.created_at < self.event_achievement.start_date
      errors.add(
        :user_id,
        "super event only for new users"
      )
    end
  end
end
