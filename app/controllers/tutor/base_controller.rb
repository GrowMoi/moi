module Tutor
  class BaseController < ::ApplicationController
    include JsonRequestsForgeryBypass
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :restrict_cliente!

    private

    def restrict_cliente!
      redirect_to(
        root_path,
        error: I18n.t("views.unauthorized")
      ) if current_user.cliente?
    end
  end
end
