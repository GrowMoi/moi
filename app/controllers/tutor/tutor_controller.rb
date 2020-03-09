module Tutor
  class TutorController < BaseController

    before_action :authenticate_user!
    before_action :restrict_cliente!

    private

    def restrict_cliente!
      respond_to(
        status: :forbidden,
        error: I18n.t("views.unauthorized")
      ) if current_user.cliente?
    end

  end
end
