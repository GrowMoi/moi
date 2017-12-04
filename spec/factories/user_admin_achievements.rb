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

FactoryGirl.define do
  factory :user_admin_achievement do
    
  end

end
