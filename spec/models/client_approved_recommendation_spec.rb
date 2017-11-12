require 'rails_helper'

RSpec.describe ClientApprovedRecommendation, :type => :model do
  describe "factory" do
    let(:client_approved_recommendation) { build :client_approved_recommendation }
    it { expect(client_approved_recommendation).to be_valid }
  end
end
