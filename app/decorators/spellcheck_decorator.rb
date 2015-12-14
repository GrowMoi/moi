class SpellcheckDecorator < LittleDecorator
  def spellchecked(name)
    if analysis_map[name].present?
      analysis_map[name].html_safe
    elsif record.send(name).present?
      content_tag(
        :span,
        record.send(name)
      ) + spellcheck_error.html_safe
    end
  end

  private

  def analysis_map
    @analysis_map ||= spellcheck_analyses.inject({}) do |memo, analysis|
      if analysis.success?
        memo[analysis.attr_name] = spellchecked_attr(analysis)
      end
      memo
    end
  end

  def spellchecked_attr(analysis)
    analysis.words.inject(
      record.send(analysis.attr_name)
    ) do |text, word|
      " #{text} ".gsub(
        /\s#{word["original"]}\s/i,
        " #{suggestions_for(word)} "
      ).squish
    end
  end

  def suggestions_for(word)
    content_tag(
      :span,
      word["original"],
      class: "bs-tooltip text-danger",
      title: word["suggestions"].join(" | ")
    )
  end

  def spellcheck_error
    content_tag(
      :span,
      nil,
      class: "glyphicon glyphicon-exclamation-sign bs-tooltip spellcheck-error",
      title: I18n.t("views.contents.aspell_not_present")
    )
  end
end
