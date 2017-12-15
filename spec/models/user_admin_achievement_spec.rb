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

require 'rails_helper'

RSpec.describe UserAdminAchievement, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
