# == Schema Information
#
# Table name: tutor_achievements
#
#  id          :integer          not null, primary key
#  tutor_id    :integer          not null
#  name        :string           not null
#  description :text
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorAchievement, :type => :model do
  describe "factory" do
    let(:tutor_achievement) { build :tutor_achievement }
    it { expect(tutor_achievement).to be_valid }
  end
end
