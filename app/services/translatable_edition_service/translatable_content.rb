require "translatable_edition_service/generic_translatable_resource"
require "translatable_edition_service/translatable_possible_answer"

class TranslatableContent < GenericTranslatableResource
  def initialize(content:, target_lang:)
    @resource = content
    @target_lang = target_lang
  end

  def translate!
    translate_possible_answers!
    translate_attributes!
  end

  private

  def translate_possible_answers!
    @resource.possible_answers.each do |possible_answer|
      TranslatablePossibleAnswer.new(
        possible_answer: possible_answer,
        target_lang: @target_lang
      ).translate!
    end
  end
end
