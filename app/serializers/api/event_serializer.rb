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
      lang = current_user.preferred_lang
      unless lang == ApplicationController::DEFAULT_LANGUAGE
        resp = TranslatedAttribute.where(translatable_id: object.id, name: "title").last
        return title = resp ? resp.content : object.title
      end
      title = object.title
    end

    def description
      lang = current_user.preferred_lang
      unless lang == ApplicationController::DEFAULT_LANGUAGE
        resp = TranslatedAttribute.where(translatable_id: object.id, name: "description").last
        return description = resp ? resp.content : object.description
      end
      description = object.description
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
      ids = object.content_ids.map.reject { |id| id.empty? }
      branches_neurons_ids = TreeService::NeuronsFetcher.new(nil).neurons_ids_by_branch
      ids.map do |id|
        content = Content.find(id)
        neuron = content.neuron
        title = neuron.title
        lang = current_user.preferred_lang
        unless lang == ApplicationController::DEFAULT_LANGUAGE
          resp = TranslatedAttribute.where(translatable_id: neuron.id, name: "title").last
          title = resp ? resp.content : title
        end
        {
          content_id: id,
          neuron: title,
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
  end
end
