require "rails_helper"

describe "neurons as curador" do
  let!(:current_user) { create :user, :curador }

  before {
    login_as current_user
  }

  feature "curador can create neurons" do
    let(:neuron_attrs) { attributes_for :neuron }
    let(:fill_form!) {
      neuron_attrs.each do |key, value|
        label = I18n.t("activerecord.attributes.neuron.#{key}")
        fill_in label, with: value
      end
    }

    before {
      visit new_admin_neuron_path
      fill_form!
      expect {
        find("input[type='submit']").click
      }.to change{ Neuron.count }.by(1)
    }

    it {
      expect(page).to have_text(I18n.t("views.neurons.created"))
    }
  end
end
