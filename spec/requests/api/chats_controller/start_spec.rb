require "rails_helper"

RSpec.describe Api::ChatsController, type: :request do
  let(:current_user) { create :user }
  let(:target_user) { create :user }
  let(:create_endpoint) { "/api/chats/start/#{target_user.id}" }

  describe "starts a new chat" do
    before do
      current_user
      target_user

      login_as current_user

      expect {
        post(create_endpoint)
      }.to change {
        current_user.sent_chats.count
      }.by(1)
    end

    it "answer contains chat message" do
      expect(response.status).to eq(201)
      chat = UserChat.last
      expect(chat.kind).to be_system
    end

    it "creates notification record in DB" do
      notification = Notification.where(user: target_user).last
      expect(notification.client_id).to eq(current_user.id)
    end
  end
end
