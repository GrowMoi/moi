# == Schema Information
#
# Table name: leaderboards
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  time_elapsed    :integer          default(0)
#  contents_learnt :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  achievements    :integer          default(0)
#

class Leaderboard < ActiveRecord::Base
  belongs_to :user
  validates :user_id,
            presence: true
end
