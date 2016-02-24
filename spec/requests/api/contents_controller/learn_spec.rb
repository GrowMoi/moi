require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  let(:current_user) { create :user }
  let(:neuron) { create :neuron, :public }
  let!(:content) {
    create :content,
           :approved,
           neuron: neuron
  }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/learn"
  }

  describe "#learn" do
    before { login_as current_user }

    before {
      expect { post endpoint }.to change {
        current_user.learned_contents.count
      }.by(1)
    }

    it {
      expect(response).to have_http_status(:created)
      expect(
        current_user.learned_contents
      ).to include(content)
    }
  end

  describe "unauthenticated #learn" do
    before { post endpoint }

    it {
      expect(response).to have_http_status(:unauthorized)
    }
  end

  describe "already learnt #learn" do
    let!(:learning) {
      create :content_learning,
             content: content,
             user: current_user
    }

    before { login_as current_user }

    before {
      expect { post endpoint }.to_not change {
        current_user.learned_contents.count
      }
    }

    it {
      expect(response).to have_http_status(:unprocessable_entity)
    }
  end
end
