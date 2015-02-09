module Admin
  module AdminController
    class Base < ::ApplicationController
      layout "admin"

      before_action :authenticate_user!
      before_action :require_admin!

      private

      def require_admin!
        redirect_to(
          root_path,
          error: I18n.t("views.unauthorized")
        ) unless current_user.admin?
      end
    end
  end
end
