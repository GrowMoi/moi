module Admin
  module AdminController
    class Base < ::ApplicationController
      layout "admin"

      before_action :authenticate_user!
      before_action :restrict_cliente!

      private

      def restrict_cliente!
        redirect_to(
          root_path,
          error: I18n.t("views.unauthorized")
        ) if current_user.cliente?
      end

      # for navbar
      def nav_item
        self.class.name
      end
    end
  end
end
