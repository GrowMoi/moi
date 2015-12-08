module Api
  class SessionsController < DeviseTokenAuth::SessionsController
    extend BaseDoc
    include DeviseTokenAuth::Concerns::SetUserByToken
    include BaseController::JsonRequestsForgeryBypass

    resource_description do
      short "user session"
      description "sessions handled by `devise_token_auth` gem"
    end

    doc_for :sign_in do
      api :POST,
          "/auth/user/sign_in",
          "login"
      description "authenticate using email and password"
      param :email, String, required: true
      param :password, String, required: true
      example '{"success":true,"data":{"id":1,"email":"somebody@example.com","name":"Somebody","role":"role","uid":"somebody@example.com","provider":"email"}}'
    end

    doc_for :sign_out do
      api :DELETE,
          "/auth/user/sign_out",
          "log out"
      description "aka end session"
    end
  end
end
