# == Schema Information
#
# Table name: client_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  client_id               :integer          not null
#  tutor_recommendation_id :integer          not null
#  status                  :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe ClientTutorRecommendation, :type => :model do
  describe "factory" do
    let(:client_tutor_recommendation) { build :client_tutor_recommendation }
    it { expect(client_tutor_recommendation).to be_valid }
  end
end
