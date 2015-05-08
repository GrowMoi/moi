class SearchEngineDecorator < LittleDecorator
  def status_label
    type = active ? "success" : "default"
    content_tag :span,
                class: "label label-#{type} search-engine-status" do
      I18n.t("views.search_engine.active_status.#{active}")
    end
  end

  def to_s
    record.to_s
  end
end
