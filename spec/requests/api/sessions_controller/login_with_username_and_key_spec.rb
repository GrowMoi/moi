require "rails_helper"

RSpec.describe Api::SessionsController,
               type: :request do
  describe "login using username & key" do
    it {
      user = create :user, :with_username, :with_authorization_key
      params = { login: user.username, authorization_key: user.authorization_key }
      post "/api/auth/user/key_authorize", params
      expect(response.body).to include(user.username)
    }
  end
end
