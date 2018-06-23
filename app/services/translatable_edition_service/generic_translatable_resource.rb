class GenericTranslatableResource
  protected

  def translate_attributes!
    @resource.class.translated_attrs.each do |attribute|
      translated_value = @resource.send(attribute)
      if @resource.send("#{attribute}_changed?")
        translated_attr = get_translated_attribute_for(attribute)
        translated_attr.content = translated_value
        translated_attr.save!
      end
    end
  end

  def get_translated_attribute_for(attribute_name)
    @resource.translated_attributes.where(
      name: attribute_name,
      language: @target_lang
    ).first_or_initialize
  end
end
