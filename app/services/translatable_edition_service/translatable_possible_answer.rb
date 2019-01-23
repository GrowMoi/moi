require "translatable_edition_service/generic_translatable_resource"

class TranslatablePossibleAnswer < GenericTranslatableResource
  def initialize(possible_answer:, target_lang:)
    @resource = possible_answer
    @target_lang = target_lang
  end

  def translate!
    translate_attributes!
  end
end
