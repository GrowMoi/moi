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
  class EventSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :description,
               :image,
               :contents,
               :duration,
               :kind,
               :user_level,
               :is_available

    def image
      image = object.image
      image ? image.url : ''
    end

    def contents
      ids = object.content_ids.map.reject { |id| id.empty? }
      ids.map do |id|
        content = Content.find(id)
        {
          content_id: id,
          neuron: content.neuron.title
        }
      end
    end

    def is_available
      !current_user.user_events.find_by_event_id(object.id)
    end

    alias_method :current_user, :scope
  end
end
