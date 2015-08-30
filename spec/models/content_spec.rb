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

  #approved content by default false
  let(:content) { build :content }

  describe "factory" do
    it{ expect(content).to be_valid }
  end

  describe "neuron should not to be active" do
    it {
      expect(content.neuron.active).to eq(false)
    }
  end

  describe "neuron should to be active" do
    before {
      content.update! approved: true
    }

    it {
      expect(content.neuron.active).to eq(true)
    }
  end
end
