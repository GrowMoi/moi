require 'rails_helper'

RSpec.describe Neuron, :type => :model do
  context "a neuron can have a parent" do
    let(:neuron) {
      create :neuron, :with_parent
    }

    before {
      expect {
        neuron
      }.to change{ Neuron.count }.by(2)
    }

    it {
      expect(neuron.parent).to be_present
    }
  end
end
