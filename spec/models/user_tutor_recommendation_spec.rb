# == Schema Information
#
# Table name: user_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  user_tutor_id           :integer          not null
#  tutor_recommendation_id :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe UserTutorRecommendation, :type => :model do
  describe "factory" do
    let(:user_tutor_recommendation) { build :user_tutor_recommendation }
    it { expect(user_tutor_recommendation).to be_valid }
  end
end
