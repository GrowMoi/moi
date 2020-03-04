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
#

class Leaderboard < ActiveRecord::Base
  belongs_to :user
  validates :user_id,
            presence: true

  delegate :age,
           :city,
           :email,
           :image,
           :school,
           :username,
           :birth_year,
           to: :user, prefix: true
end
