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

    it "paginated" do
      user = create :user
      user_tutors = 3.times.map do
        create :user_tutor, user: user
      end
      login_as user
      get "/api/notifications/new"
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["user_tutors"].count).to eq(Api::NotificationsController::PER_PAGE)
      expect(parsed_body["meta"]["total_pages"]).to eq(2)
      expect(parsed_body["meta"]["total_count"]).to eq(user_tutors.count)
    end
  end
end
