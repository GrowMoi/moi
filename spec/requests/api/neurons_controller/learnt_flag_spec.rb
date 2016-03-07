require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "neurons_controller:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

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
