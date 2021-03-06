# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  description    :string
#  image          :string
#  inactive_image :string
#  content_ids    :text             default([]), is an Array
#  publish_days   :text             default([]), is an Array
#  duration       :integer          not null
#  kind           :string
#  user_level     :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module Api
  class EventSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :description,
               :image,
               :inactive_image,
               :contents,
               :duration,
               :kind,
               :user_level,
               :is_available,
               :completed

    def title
      title = get_translation("title")
    end

    def description
      description = get_translation("description")
    end

    def image
      image = object.image
      image ? image.url : ''
    end

    def inactive_image
      inactive_image = object.inactive_image
      inactive_image ? inactive_image.url : ''
    end

    def contents
      branches_neurons_ids = TreeService::NeuronsFetcher.new(nil).neurons_ids_by_branch
      contents = Content.includes(:neuron).where(id: object.content_ids)
      contents.map do |content|
        neuron = content.neuron
        neuron_title = neuron.title
        lang = current_user.preferred_lang
        unless lang == ApplicationController::DEFAULT_LANGUAGE
          resp = TranslatedAttribute.where(translatable_id: neuron.id, name: "title", translatable_type: "Neuron").last
          neuron_title = resp ? resp.content : neuron_title
        end
        {
          content_id: content.id,
          neuron: neuron_title,
          neuron_color: TreeService::NeuronsFetcher.new(neuron).neuron_color(branches_neurons_ids)
        }
      end
    end

    def is_available
      !current_user.user_events.find_by_event_id(object.id)
    end

    def completed
      event_user = current_user.user_events.find_by_event_id(object.id)
      event_user ? event_user.completed : false
    end

    alias_method :current_user, :scope

    private

    def get_translation(attribute)
      lang = current_user.preferred_lang

      unless lang == ApplicationController::DEFAULT_LANGUAGE
        resp = TranslatedAttribute.where(translatable_id: object.id, name: attribute, translatable_type:"Event").last
        return title = resp ? resp.content : object.title
      end

      return object[attribute]
    end
  end
end
