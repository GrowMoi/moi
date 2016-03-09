require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "neurons_controller:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  describe "includes videos in content" do
    let!(:content_video) {
      create :content_video,
             content: content
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["videos"]
      ).to include(content_video.url)
    }
  end
end
