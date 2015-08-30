require "rails_helper"

describe "neuron search", type: :feature do
  let(:state) { :active }
  let(:name_one) { "common RTY" }
  let(:name_two) { "common QWE" }
  let!(:other_content) {
    create :content, description: "other"
  }
  let!(:neuron_one) {
    create(:neuron, state).tap do |neuron|
      create(:content, description: name_one,
                       neuron: neuron,
                       approved: true)
    end
  }
  let!(:deleted_neuron) {
    create(:neuron, state, :deleted).tap do |neuron|
      create(:content, description: name_two,
                       neuron: neuron,
                       approved: true)
    end
  }
  before {
    login_as current_user
    visit admin_root_path # or dashboard path
    fill_in :q, with: "common"
    click_on I18n.t("actions.search")
  }
  describe "as curador" do
    let!(:current_user) {
      create :user, :curador
    }
    it {
      expect(page.html).to have_content(neuron_one.title)
    }
    it "can't see deleted neurons" do
      expect(page.html).to_not have_content(deleted_neuron.title)
    end
    it "filters content" do
      expect(
        page.html
      ).to_not have_content(other_content.neuron.title)
    end
  end
  describe "as moderador" do
    pending
  end
  describe "as admin" do
    let!(:current_user) {
      create :user, :admin
    }
    it "can see all neurons" do
      expect(page.html).to have_content(neuron_one.title)
      expect(page.html).to have_content(deleted_neuron.title)
    end
    it "filters content" do
      expect(
        page.html
      ).to_not have_content(other_content.neuron.title)
    end
  end
end
