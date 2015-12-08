module Api
  class BaseController < ::ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include JsonRequestsForgeryBypass
  end
end
