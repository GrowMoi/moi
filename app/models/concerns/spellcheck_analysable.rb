module SpellcheckAnalysable
  extend ActiveSupport::Concern

  included do
    # relationships
    has_many :spellcheck_analyses, as: :analysable

    # callbacks
    before_save :expire_spellcheck_analysis!
    after_save :schedule_spellcheck_analysis!
  end

  private

  ##
  # destroys spelling analysis records
  # for dirty attributes
  def expire_spellcheck_analysis!
    spellcheck_attributes.each do |attribute|
      if send("#{attribute}_changed?")
        spellcheck_analyses.where(
          attr_name: attribute
        ).destroy_all
      end
    end
  end

  ##
  # schedules a spellcheck analysis if
  # there's any attribute missing without
  # analysis
  def schedule_spellcheck_analysis!
    if missing_spellcheck_analysis?
      SpellingAnalysisWorker.delay.perform!(id)
    end
  end

  def missing_spellcheck_analysis?
    spellcheck_analyses.count != spellcheck_attributes.count
  end

  def spellcheck_attributes
    self.class::SPELLCHECK_ATTRIBUTES
  end
end
