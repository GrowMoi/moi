module Api
  class SessionsController < DeviseTokenAuth::SessionsController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include BaseController::JSONRequestsForgeryBypass
  end
end
