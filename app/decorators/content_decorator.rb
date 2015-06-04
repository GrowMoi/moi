class ContentDecorator < LittleDecorator
  def keywords
    content_tag :div, class: "content-keywords" do
      record.keyword_list.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def source
    if record.source.present?
      link_to record.source,
              record.source,
              target: "_blank"
    end
  end

  def description_spellchecked
    @spellchecked_description ||= spellcheck_description
  rescue RuntimeError => e
    if e.message == "Aspell command not found"
      # aspell is not present. gracefully fallback
      # to original description
      return record.description
    else
      raise e
    end
  end

  private

  def spellcheck_description
    Spellchecker.check(
      record.description.to_s,
      I18n.locale.to_s
    ).map do |w|
      if w[:correct]
        w[:original]
      else
        suggestions = w[:suggestions].first(3).join(" | ")
        content_tag(:span,
                    w[:original] + " ",
                    class: "bs-tooltip text-danger",
                    title: suggestions)
      end
    end.join(" ").html_safe
  end
end
