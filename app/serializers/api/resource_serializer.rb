module Api
  class ResourceSerializer < ActiveModel::Serializer
    class << self
      def translates(*attribute_names)
        attribute_names.each do |attr_name|
          define_method attr_name do
            public_send(:translate, attr_name)
          end
        end
      end
    end

    def translate(attribute_name)
      if current_user.preferred_lang == ApplicationController::DEFAULT_LANGUAGE
        object.send(attribute_name)
      else
        TranslateAttributeService.translate(
          object,
          attribute_name,
          current_user.preferred_lang
        ).presence || object.send(attribute_name)
      end
    end
  end
end
