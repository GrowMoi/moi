class TranslationDecorator < LittleDecorator
  def translated(name)
    translation = translation_for(name)
    if translation.present?
      translation
    else
      translation_not_present.html_safe + content_tag(
        :span,
        record.send(name),
        class: "text-warning"
      ).html_safe
    end
  end

  private

  def translation_not_present
    content_tag(
      :span,
      class: "translation-not-present bs-tooltip",
      title: I18n.t("views.translation_not_present")
    ) do
      content_tag(
        :span,
        nil,
        class: "glyphicon glyphicon-exclamation-sign"
      ) + content_tag(
        :span,
        nil,
        class: "glyphicon glyphicon-globe"
      )
    end
  end

  def translation_for(name)
    TranslateAttributeService.translate(
      record,
      name,
      current_language
    )
  end
end
