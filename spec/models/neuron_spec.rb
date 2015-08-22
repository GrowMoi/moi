# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Neuron, :type => :model do
  describe "a neuron can have a parent" do
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

  describe "parent can't be child" do
    let(:parent) {
      create :neuron
    }
    let(:child) {
      create :neuron, parent: parent
    }
    let(:child2) {
      create :neuron, parent: child
    }

    before {
      child.parent = child2
    }

    it {
      expect(child).to_not be_valid
      expect(child.errors.keys).to include(:parent)
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

  describe "#save_with_version", versioning: true do
    let(:neuron) { build :neuron }
    let(:invalid_neuron) { build :neuron, title: nil }

    it "returns same as #save" do
      expect(neuron.save_with_version).to be_truthy
      expect(invalid_neuron.save_with_version).to be_falsy
    end

    describe "creates version" do
      let!(:content) { create :content, neuron: neuron }
      let(:versions) { PaperTrail::Version.last(2) }
      let(:attrs) {
        {
          contents_attributes: {
            :"0" => attributes_for(:content)
          }
        }
      }

      before {
        neuron.save
        neuron.attributes = attrs # assign changes
      }

      subject {
        -> { neuron.save_with_version }
      }

      it {
        is_expected.to change(PaperTrail::Version, :count).by(2)
      }

      it {
        subject.call
        expect(
          versions[0].transaction_id
        ).to eq(versions[1].transaction_id)
      }
    end
  end
end
