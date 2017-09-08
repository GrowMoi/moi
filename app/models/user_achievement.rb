# == Schema Information
#
# Table name: user_achievements
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  achievement_id :integer          not null
#  meta           :json
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class UserAchievement < ActiveRecord::Base
  belongs_to :user
  belongs_to :achievement
  validates :user_id,
            presence: true
  validates :achievement_id,
            presence: true
end
