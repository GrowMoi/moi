# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  describe "#build_contents!" do
    let(:neuron) { build :neuron }
    let(:levels) { Content::LEVELS }
    let(:kinds) { Content::KINDS }

    before { neuron.build_contents! }

    it "should include all levels" do
      levels.each do |level|
        expect(
          neuron.contents.any? do |content|
            content.level == level
          end
        ).to be_truthy
      end
    end

    it "should include all kinds in all levels" do
      levels.each do |level|
        kinds.each do |kind|
          expect(
            neuron.contents.any? do |content|
              content.level == level &&
              content.kind == kind
            end
          ).to be_truthy
        end
      end
    end

    it {
      expect(
        neuron.contents.length
      ).to eq( levels.count * kinds.count )
    }
  end
end
