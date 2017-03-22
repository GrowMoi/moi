require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  describe "not read content" do
    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["read"]
      ).to be_falsey
    }
  end

  describe "read content" do
    let!(:reading) {
      create :content_reading,
             content: content,
             user: current_user
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["read"]
      ).to be_truthy
    }
  end

  describe "content can be readed" do
    let!(:reading) {
      create :content_reading,
             content: content,
             user: current_user
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["can_read"]
      ).to be_truthy
    }
  end
end
