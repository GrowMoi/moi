# == Schema Information
#
# Table name: content_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  content_id              :integer          not null
#  tutor_recommendation_id :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentTutorRecommendation, :type => :model do
  describe "factory" do
    let(:content_tutor_recommendation) { build :content_tutor_recommendation }
    it { expect(content_tutor_recommendation).to be_valid }
  end
end
