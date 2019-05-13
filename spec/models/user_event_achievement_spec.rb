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

require 'rails_helper'

RSpec.describe UserEventAchievement, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
