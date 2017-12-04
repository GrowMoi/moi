# == Schema Information
#
# Table name: tutor_recommendations
#
#  id                   :integer          not null, primary key
#  tutor_id             :integer          not null
#  tutor_achievement_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorRecommendation, :type => :model do
  describe "factory" do
    let(:tutor_recommendation) { build :tutor_recommendation }
    it { expect(tutor_recommendation).to be_valid }
  end
end
