require "rails_helper"

RSpec.describe Api::UserTutorsController,
               type: :request do
  describe "respond to tutor requests" do
    it "accepts tutor request" do
      user = create :user
      tutor_request = create :user_tutor, user: user
      login_as user
      post "/api/user_tutors/#{tutor_request.id}/respond",
           response: :accepted
      user_tutor = JSON.parse(response.body)["user_tutor"]
      expect(user_tutor["status"]).to eq("accepted")
    end

    it "rejects tutor request" do
      user = create :user
      tutor_request = create :user_tutor, user: user
      login_as user
      expect {
        post "/api/user_tutors/#{tutor_request.id}/respond",
             response: :rejected
      }.to change { UserTutor.count }.by(-1)
      user_tutor = JSON.parse(response.body)["user_tutor"]
      expect(user_tutor["status"]).to eq("rejected")
    end
  end
end
