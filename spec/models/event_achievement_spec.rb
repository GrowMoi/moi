# == Schema Information
#
# Table name: event_achievements
#
#  id                   :integer          not null, primary key
#  user_achievement_ids :integer          default([]), is an Array
#  title                :string           not null
#  start_date           :datetime         not null
#  end_date             :datetime         not null
#  image                :string
#  message              :text
#  new_users            :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :string
#  inactive_image       :string
#

require 'rails_helper'

RSpec.describe EventAchievement, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
