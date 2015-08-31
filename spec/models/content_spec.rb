# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  media       :string
#  approved    :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Content, :type => :model do
  let(:content) { build :content }
  let(:neuron) { content.neuron }

  describe "factory" do
    it{ expect(content).to be_valid }
  end

  describe "neuron should not to be active" do
    it {
      expect(content.neuron.active).to eq(false)
    }
  end

  describe "neuron should change to be active" do
    before {
      content.update! approved: true
    }

    it {
      expect(neuron).to be_active
    }
  end

  describe "neuron should return to be inactive" do
    let(:content) {
      create :content, :approved
    }
    before {
      expect(neuron.reload).to be_active
      content.update! approved: false
    }
    it {
      expect(neuron.reload).to_not be_active
    }
  end
end
