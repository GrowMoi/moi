require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  describe "unauthenticated #index" do
    let!(:neuron) {
      # we rely on root being present
      create :neuron
    }
    before { get "/api/neurons" }
    subject { response }
    it {
      is_expected.to have_http_status(:unauthorized)
    }
  end
end
