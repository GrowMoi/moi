module Admin
  module AdminController
    class Base < ::ApplicationController
      layout "admin"

      before_action :authenticate_user!
      before_action :require_admin!

      private

      def require_admin!
        # TODO
      end
    end
  end
end
