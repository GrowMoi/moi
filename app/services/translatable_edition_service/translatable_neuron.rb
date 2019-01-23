require "translatable_edition_service/generic_translatable_resource"

class TranslatableNeuron < GenericTranslatableResource
  def initialize(neuron:, target_lang:)
    @resource = neuron
    @target_lang = target_lang
  end

  def translate!
    @resource
    translate_attributes!
  end
end
