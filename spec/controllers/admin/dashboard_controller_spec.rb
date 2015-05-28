require "rails_helper"

RSpec.describe Admin::DashboardController,
               type: :controller do
  describe "Approved and pending neurons" do
    let!(:current_user) {
      create :user, :admin
    }

    # default neuron state is pending
    let!(:pending_neuron) { create :neuron }

    let!(:approved_neuron) {
      create :neuron, state: :approved
    }

    before {
      sign_in current_user
    }

    it {
      expect(pending_neuron.state).to eq("pending")
    }

    describe "should get approved neuron" do
      before {
        get :index, state: 'approved'
      }

      it {
        expect(controller.neurons).to include(approved_neuron)
      }
    end

    describe "should get pending neuron" do
      before {
        get :index, state: 'pending'
      }

      it {
        expect(controller.neurons).to include(pending_neuron)
      }
    end

    describe "invalid params" do
      before {
        get :index, state: "something-bad"
      }

      it "uses default scope" do
        expect(controller.neurons).to include(approved_neuron)
      end
    end
  end
end
