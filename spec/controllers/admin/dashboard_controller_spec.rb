require "rails_helper"

RSpec.describe Admin::DashboardController,
               type: :controller do
  describe "Approved and pending neurons" do
    let!(:current_user) {
      create :user, :admin
    }

    #default neuron is state pending
    let!(:pending_neuron) { create :neuron }

    let!(:approved_neuron) {
      create :neuron, state: :approved
    }

    describe "should get approved neuron" do
      before {
        sign_in current_user
        get :index, state: 'approved'
      }

      it {
        expect(controller.neurons).to include(approved_neuron)
      }
    end

    describe "should get pending neuron" do
      before {
        sign_in current_user
        get :index, state: 'pending'
      }

      it {
        expect(controller.neurons).to include(pending_neuron)
      }
    end
  end
end
