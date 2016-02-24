require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  let(:neuron) {
    create :neuron, :public
  }
  let!(:content) {
    create :content,
           :approved,
           neuron: neuron
  }

  describe "#learn" do
    let(:current_user) { create :user }
    before { login_as current_user }

    before {
      expect {
        post "/api/neurons/#{neuron.id}/contents/#{content.id}/learn"
      }.to change {
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
    before {
      post "/api/neurons/#{neuron.id}/contents/#{content.id}/learn"
    }

    it {
      expect(response).to have_http_status(:unauthorized)
    }
  end

  describe "already learnt #learn" do
    let(:current_user) { create :user }
    before { login_as current_user }

    before {
      current_user.learn(content)

      expect {
        post "/api/neurons/#{neuron.id}/contents/#{content.id}/learn"
      }.to_not change {
        current_user.learned_contents.count
      }
    }

    it {
      expect(response).to have_http_status(:unprocessable_entity)
    }
  end
end
