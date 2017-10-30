# == Schema Information
#
# Table name: content_reading_times
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  time       :float            not null
#  created_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentReadingTime, type: :model do
  describe "factory" do
    it { expect(build(:content_reading_time)).to be_valid }
  end
end
