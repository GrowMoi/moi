require 'rails_helper'

RSpec.describe UserContentPreference,
               type: :model do
  describe "factory" do
    subject { build :user_content_preference }
    it { is_expected.to be_valid }
  end
end
