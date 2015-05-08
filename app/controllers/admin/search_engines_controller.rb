module Admin
  class SearchEnginesController < SettingsController
    expose(:search_engine) {
      decorate SearchEngine.find(params[:id])
    }

    private

    def add_breadcrumbs
      breadcrumb_for "index"
      send "breadcrumb_for_#{action_name}"
    end

    def breadcrumb_for_show
      add_breadcrumb(
        I18n.t("views.search_engines")
      )
      add_breadcrumb search_engine
    end
  end
end
