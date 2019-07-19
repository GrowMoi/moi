require "translatable_edition_service/generic_translatable_resource"

class TranslatableEvent < GenericTranslatableResource
  def initialize(event:, target_lang:)
    @resource = event
    @target_lang = target_lang
  end

  def save
    case @target_lang
    when ApplicationController::DEFAULT_LANGUAGE
      @resource.save
    when "en"
      translate!
      @resource.reload
    end
  end

  def translate!
    @resource
    translate_attributes!
  end
end
