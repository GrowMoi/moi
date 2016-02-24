# == Schema Information
#
# Table name: content_notes
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  note       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentNote,
               type: :model do
  describe "factory" do
    subject { build :content_note }
    it { is_expected.to be_valid }
    it {
      expect(subject.user).to be_present
    }
    it {
      expect(subject.content).to be_present
    }
    it {
      expect(subject.note).to be_present
    }
  end
end
