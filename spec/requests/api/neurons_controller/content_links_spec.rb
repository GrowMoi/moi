require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  describe "includes links in content" do
    let!(:content_link) {
      create :content_link,
             content: content
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["links"]
      ).to include(content_link.link)
    }
  end
end
