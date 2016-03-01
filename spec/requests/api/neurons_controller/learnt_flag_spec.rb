require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  let(:current_user) { create :user }
  let(:neuron) { create :neuron, :public }
  let!(:content) {
    create :content,
           :approved,
           neuron: neuron
  }

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  before { login_as current_user }

  describe "not learnt content" do
    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["learnt"]
      ).to be_falsey
    }
  end

  describe "learnt content" do
    let!(:learning) {
      create :content_learning,
             content: content,
             user: current_user
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["learnt"]
      ).to be_truthy
    }
  end
end