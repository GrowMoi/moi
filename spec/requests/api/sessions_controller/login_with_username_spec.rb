require "rails_helper"

RSpec.describe Api::SessionsController,
               type: :request do
  describe "login using username" do
    it {
      user = create :user, :with_username
      params = { login: user.username, password: user.password }
      post "/api/auth/user/sign_in", params
      expect(response.body).to include(user.username)
    }
  end
end
