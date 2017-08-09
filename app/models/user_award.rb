# == Schema Information
#
# Table name: user_awards
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  award_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserAward < ActiveRecord::Base
  belongs_to :user
  belongs_to :award
  validates :user_id,
            presence: true
  validates :award_id,
            presence: true
end
