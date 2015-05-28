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

  def spellcheck_description
    description = record.description || ""
    results = Spellchecker.check(description, dictionary = I18n.locale.to_s)
    words = content_tag :div do
      content_words = content_tag(:span)
      results.each do |w|
        if w[:correct]
          word = w[:original]
        else
          suggestions = w[:suggestions].take(3)
          suggestions = suggestions.join(" | ")
          word = content_tag(:span, "#{w[:original]}",
            class: " bs-tooltip text-danger",
            title: suggestions,
            "data-toggle" => "tooltip",
            "data-placement" => "top" )
        end
        content_words = content_words + " " + word
      end
      content_words
    end
    return words
  end

end
