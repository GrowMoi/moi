module Admin
  class SettingsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    expose(:search_engines) do
      decorate SearchEngine.all
    end

    private

    def breadcrumb_base
      "settings"
    end
  end
end
