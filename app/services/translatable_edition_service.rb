require "translatable_edition_service/translatable_content"
require "translatable_edition_service/translatable_neuron"

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
      translate_neuron!
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

  def translate_neuron!
    TranslatableNeuron.new(
      neuron: @neuron,
      target_lang: @target_lang
    ).translate!
  end
end
