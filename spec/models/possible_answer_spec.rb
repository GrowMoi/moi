# == Schema Information
#
# Table name: possible_answers
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  text       :string           not null
#  correct    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PossibleAnswer, :type => :model do
  describe "factory" do
    let(:possible_answer) { build :possible_answer }
    it { expect(possible_answer).to be_valid }
  end
end
