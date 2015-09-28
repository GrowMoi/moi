require "rails_helper"

describe "update flag neuron" do
  let!(:current_user) { create :user, :admin }

  let!(:neuron) {
    create :neuron
  }

  let!(:content) {
    create :content, neuron: neuron
  }

  before {
    login_as current_user
    visit admin_neuron_path(neuron)
  }

  feature "approve content", js: true do
    before {
      # I can't found link
      # content.approved?
      # click_link I18n.t("views.contents.approved_status.unapproved")
    }

    it {
      pending
      # expect(record.attr).to eq(true)
    }
  end

end
