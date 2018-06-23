module TranslatableAttrs
  extend ActiveSupport::Concern

  included do
    cattr_accessor :translated_attrs
    has_many :translated_attributes, as: :translatable
  end

  module ClassMethods
    def translates(*attributes)
      self.translated_attrs = attributes
    end
  end
end
