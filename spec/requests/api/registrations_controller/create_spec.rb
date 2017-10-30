require "rails_helper"

RSpec.describe Api::RegistrationsController,
               type: :request do
  describe "sign up" do
    it "persists attributes" do
      params = {
        username: 'moi-user-1',
        age: '14',
        email: 'moi-user-1@email.com',
        city: 'Loxa',
        country: 'Ecuador',
        school: 'Simón Bolívar',
        authorization_key: 'animals'
      }
      post '/users', params
      response = JSON.parse(response.body)
      user = response.fetch("data")
      expect(user["username"]).to eq(params[:username])
      expect(user["name"]).to eq(params[:username])
      expect(user["age"]).to eq(14)
      expect(user["authorization_key"]).to eq(params[:authorization_key])
    end
  end
end
