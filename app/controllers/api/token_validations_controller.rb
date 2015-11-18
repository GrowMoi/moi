module Api
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include BaseController::JSONRequestsForgeryBypass
  end
end
