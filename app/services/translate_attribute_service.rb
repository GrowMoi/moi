class TranslateAttributeService
  def self.translate(resource, attribute, target_lang)
    if target_lang == ApplicationController::DEFAULT_LANGUAGE
      resource.send(attribute)
    else
      new(resource, attribute, target_lang).translate
    end
  end

  def initialize(resource, attribute, target_lang)
    @resource = resource
    @attribute = attribute
    @target_lang = target_lang
  end

  def translate
    attribute_translation = get_translation
    attribute_translation.presence && attribute_translation.content
  end

  private

  def get_translation
    @resource.translated_attributes.where(
      name: @attribute,
      language: @target_lang
    ).first
  end
end
