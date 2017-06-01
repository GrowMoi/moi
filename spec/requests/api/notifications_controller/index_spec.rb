require "rails_helper"

RSpec.describe Api::NotificationsController,
               type: :request do
  describe "new notifications" do
    it "includes new tutor request" do
      user = create :user
      tutor_request = create :user_tutor, user: user
      login_as user
      get "/api/notifications/new"
      user_tutors = JSON.parse(response.body)["user_tutors"]
      expect(
        user_tutors.first["id"]
      ).to eq(tutor_request.id)
    end
  end
end
