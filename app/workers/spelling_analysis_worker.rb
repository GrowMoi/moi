class SpellingAnalysisWorker
  attr_reader :resource

  LANG = I18n.locale.to_s # es
  SUGGESTIONS = 3

  def initialize(resource)
    @resource = resource
  end

  def run!
    attributes_to_analyse.each do |attribute|
      text = resource.send(attribute)
      create_analysis!(attribute, text) if text.present?
    end
  end

  private

  ##
  # creates spellcheck analysis
  # rescues when aspell is not present
  def create_analysis!(attribute, text)
    words = formatted_mispelled_words_for(text)
    resource.spellcheck_analyses.create!(
      attr_name: attribute,
      words: words,
      success: true
    )
  rescue RuntimeError => e
    if e.message == "Aspell command not found"
      # aspell is not present. track analysis as failure
      resource.spellcheck_analyses.create!(
        attr_name: attribute,
        success: false
      )
    else
      raise e
    end
  end

  ##
  # we'll only analyse attributes that
  # have changed
  def attributes_to_analyse
    resource.send(:spellcheck_attributes) - resource.spellcheck_analyses.pluck(:attr_name)
  end

  ##
  # store a limited ammount of suggestions
  # and discard :correct property
  def formatted_mispelled_words_for(text)
    mispelled_words_for(text).map do |word|
      {
        original: word[:original],
        suggestions: word[:suggestions].sample(SUGGESTIONS) # or .first(3)
      }
    end
  end

  ##
  # call spellchecker and reject correct
  # words
  def mispelled_words_for(text)
    Spellchecker.check(text, LANG).reject do |word|
      word[:correct]
    end
  end

  class << self
    def perform!(id)
      new(Content.find(id)).run!
    end
  end
end
