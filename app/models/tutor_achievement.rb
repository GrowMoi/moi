# == Schema Information
#
# Table name: tutor_achievements
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  name        :string           not null
#  description :text
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TutorAchievement < ActiveRecord::Base
  belongs_to :user
  validates :user_id,
            presence: true
  has_many :tutor_recommendations
end
