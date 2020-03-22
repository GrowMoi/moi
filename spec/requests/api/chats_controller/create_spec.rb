require "rails_helper"

RSpec.describe Api::ChatsController, type: :request do
  let(:current_user) { create :user }
  let(:target_user) { create :user }
  let(:create_endpoint) { "/api/chats" }

  before { login_as current_user }

  describe "no message" do
    let(:params) do
      { receiver_id: target_user.id }
    end

    it {
      post(create_endpoint, params)
      expect(response.status).to eq(422)
    }
  end

  describe "starts a new chat" do
    let(:params) do
      {
        message: "Hello buddy!",
        receiver_id: target_user.id
      }
    end

    before do
      expect {
        post(create_endpoint, params)
      }.to change {
        current_user.sent_chats.count
      }.by(1)
    end

    it "answer contains chat message" do
      json = JSON.parse(response.body)
      chat_id = json["user_chat"]["id"]
      chat = UserChat.find(chat_id)
      expect(chat.message).to eq(params[:message])
    end
  end
end
