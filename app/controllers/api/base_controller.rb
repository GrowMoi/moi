module Api
  class BaseController < ::ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include JSONRequestsForgeryBypass
  end
end
