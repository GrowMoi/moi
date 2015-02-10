require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "factory" do
    let(:user) { build :user }

    it { expect(user).to be_valid }
  end

  describe "gets notified if role changes" do
    let(:user) { create :user }

    it {
      expect {
        user.update! role: "curador"
      }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    }
  end
end
