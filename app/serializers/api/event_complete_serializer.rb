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
      name = object.event ? object.event.title : ''
    end

    def image
      image = object.event.image
      image ? image.url : ''
    end

    def completed_at
      (object.updated_at.to_f * 1000).to_i
    end

    alias_method :current_user, :scope
  end
end
