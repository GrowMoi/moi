module Api
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    extend BaseDoc
    include BaseController::JsonRequestsForgeryBypass

    resource_description do
      short "user registration"
      description "registrations handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
    end

    doc_for :create do
      api :POST,
          "/users",
          "sign up providing email"
      description "create new account for moi. Responds with created user if successful"
      param :username, String, required: true
      param :authorization_key, String, required: true
      param :age, Integer, required: false
      param :city, String, required: false
      param :country, String, required: false
      param :email, String, required: true
      param :school, String, required: true
      param :gender, String, required: true
    end

    private

    def sign_up_params
      params.permit(
        :username,
        :email,
        :city,
        :country,
        :school,
        :authorization_key,
        :gender,
        :birth_year
      ).merge(
        password: Devise.friendly_token
      )
    end
  end
end
