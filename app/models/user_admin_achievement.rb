# == Schema Information
#
# Table name: user_admin_achievements
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  admin_achievement_id :integer          not null
#  active               :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class UserAdminAchievement < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin_achievement
  validates :user_id,
            presence: true
  validates :admin_achievement_id,
            presence: true
end
