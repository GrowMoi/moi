require "rails_helper"

describe "neurons as curador" do
  let!(:current_user) { create :user, :curador }

  before {
    login_as current_user
  }

  context "with forms" do

    let(:neuron_attrs) { attributes_for :neuron }
    let(:fill_form!) {
      neuron_attrs.each do |key, value|
        label = I18n.t("activerecord.attributes.neuron.#{key}")
        fill_in label, with: value
      end
    }

    feature "curador can create neurons" do

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

    feature "create neuron show in tree", js: true do

      before {
        visit new_admin_neuron_path
        fill_form!
        find("input[type='submit']").click
      }

      it {
        expect(page).to have_text(I18n.t("views.neurons.created"))
        expect(page).to have_text( neuron_attrs[:title])
      }
    end

    feature "update neuron", js: true do

      let(:existing_neuron) { create :neuron }

      before {
        visit edit_admin_neuron_path(existing_neuron)
        fill_form!
        expect {
          find("input[type='submit']").click
        }.to_not change(Neuron, :count)
      }

      it {
        expect(page).to have_text(I18n.t("views.neurons.updated"))
        expect(page).to have_text(neuron_attrs[:title])
      }
    end
  end
end
