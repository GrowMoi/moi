require "translatable_edition_service/translatable_content"

class TranslatableEditionService
  def initialize(neuron:, params:)
    @neuron = neuron
    @target_lang = params[:lang]
  end

  def save
    case @target_lang
    when ApplicationController::DEFAULT_LANGUAGE
      @neuron.save_with_version
    when "en"
      translate_contents!
      @neuron.reload.touch_with_version
    end
  end

  private

  def translate_contents!
    @neuron.contents.each do |content|
      TranslatableContent.new(
        content: content,
        target_lang: @target_lang
      ).translate!
    end
  end
end
