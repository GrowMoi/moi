require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  describe "#learn" do
    let(:current_user) { create :user }
    before { login_as current_user }

    let(:neuron) {
      create :neuron, :public
    }
    let!(:content) {
      create :content, :approved
    }

    before {
      post "/api/neurons/#{neuron.id}/contents/#{content.id}/learn"
    }

    it {
      binding.pry
      expect(response).to have_http_status(:created)
    }
  end
end
