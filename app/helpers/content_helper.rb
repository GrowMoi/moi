module ContentHelper
  def content_level
    I18n.t("views.contents.levels").map { |key, value| [ value, key ] }
  end

  def content_kind
    I18n.t("views.contents.kinds").map { |key, value| [ value, key ] }
  end

  def show_level(level)
    I18n.t("views.contents.levels").each do |key, value|
      if key == level
        return value
      end
    end
  end

  def show_kind(kind)
    I18n.t("views.contents.kinds").each do |key, value|
      if key == kind
        return value
      end
    end
  end
end
