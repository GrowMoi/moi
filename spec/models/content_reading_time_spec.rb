require 'rails_helper'

RSpec.describe ContentReadingTime, type: :model do
  describe "factory" do
    it { expect(build(:content_reading_time)).to be_valid }
  end
end
