require "translatable_edition_service/generic_translatable_resource"

class TranslatableEventAchievement < GenericTranslatableResource
  def initialize(event_achievement:, target_lang:)
    @resource = event_achievement
    @target_lang = target_lang
  end

  def translate!
    @resource
    translate_attributes!
  end
end
