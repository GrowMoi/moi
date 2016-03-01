require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  let(:current_user) { create :user }
  let(:neuron) { create :neuron, :public }
  let(:content) {
    create :content,
           :approved,
           neuron: neuron
  }

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  before {
    login_as current_user
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
