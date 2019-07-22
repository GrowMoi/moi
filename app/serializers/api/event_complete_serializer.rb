# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :string
#  image        :string
#  content_ids  :text             default([]), is an Array
#  publish_days :text             default([]), is an Array
#  duration     :integer          not null
#  kind         :string
#  user_level   :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Api
  class EventCompleteSerializer < ActiveModel::Serializer
    attributes :title,
               :image,
               :completed_at

    def title
      if object.is_a?(UserEvent)
        title = get_translation(object.event, "title") || ''
      else
        title = get_translation(object, "title") || ''
      end
    end

    def image
      if object.is_a?(UserEvent)
        return object.event.image ? object.event.image.url : ''
      else
        return object.image ? object.image.url : ''
      end
    end

    def completed_at
      if object.is_a?(UserEvent)
        return (object.updated_at.to_f * 1000).to_i
      end
    end

    alias_method :current_user, :scope

    private

    def get_translation(event, attribute)

      lang = current_user.preferred_lang

      unless lang == ApplicationController::DEFAULT_LANGUAGE
        resp = TranslatedAttribute.where(translatable_id: event.id, name: attribute, translatable_type:"Event").last
        return title = resp ? resp.content : event.title
      end

      return event[attribute]
    end
  end
end
