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
        return object.event.title || ''
      else
        return object.title || ''
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
  end
end
