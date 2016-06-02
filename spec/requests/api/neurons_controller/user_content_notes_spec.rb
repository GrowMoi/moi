require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  describe "includes user notes in content" do
    let!(:content_note) {
      create :content_note,
             content: content,
             user: current_user
    }

    before {
      get "/api/neurons/#{neuron.id}"
    }

    it {
      expect(
        subject["contents"].first["user_notes"]
      ).to eq(content_note.note)
    }
  end
end
