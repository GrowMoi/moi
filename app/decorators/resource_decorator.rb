class ResourceDecorator < LittleDecorator
  def spellchecked(name)
    spellcheck_analysis.spellchecked(name.to_s)
  end

  def translated(name)
    translation_service.translated(name)
  end

  def translated_or_spellchecked(name)
    if default_language?
      spellchecked(name)
    else
      translated(name)
    end
  end

  protected

  def spellcheck_analysis
    @spellcheck_analysis ||= SpellcheckDecorator.new(
      record,
      self
    )
  end

  def translation_service
    @translation_service ||= TranslationDecorator.new(
      record,
      self
    )
  end
end
