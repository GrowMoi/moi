class ContentDecorator < LittleDecorator

  def show_kind
    I18n.t("views.contents.kinds.#{kind}")
  end

  def show_level
    I18n.t("views.contents.levels.#{level}")
  end

end
