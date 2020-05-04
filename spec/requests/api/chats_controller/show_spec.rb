require "rails_helper"

RSpec.describe Api::ChatsController, type: :request do
  let(:current_user) { create :user }
  let(:target_user) { create :user }
  let(:show_endpoint) { "/api/chats/user/#{target_user.id}" }

  before { login_as current_user }

  describe "retrieves full chat" do
    let(:chat1) {
      create :user_chat,
             sender: current_user,
             receiver: target_user
    }
    let(:chat2) {
      create :user_chat,
             sender: target_user,
             receiver: current_user
    }
    let(:chat3) {
      create :user_chat,
             sender: current_user,
             receiver: target_user
    }
    let(:chat4) {
      create :user_chat,
             sender: current_user,
             receiver: create(:user)
    }

    before {
      chat1
      chat2
      chat3
      chat4
      get show_endpoint
    }

    it "answer contains full chat ordered" do
      json = JSON.parse(response.body)
      chats = json["user_chats"]
      expect(chats.count).to eq(3)
      expect(chats[0]["id"]).to eq(chat1.id)
      expect(chats[1]["id"]).to eq(chat2.id)
      expect(chats[2]["id"]).to eq(chat3.id)
      expect(chats[0]["kind"]).to eq("outgoing")
    end
  end
end
