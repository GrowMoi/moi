# == Schema Information
#
# Table name: request_content_validations
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  media      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean
#  text       :string
#

module Api
  class RequestContentValidationSerializer < ActiveModel::Serializer
    root false
    attributes  :id,
                :user_id,
                :content_id,
                :media,
                :text,
                :approved,
                :created_at,
                :in_review

    def in_review
      object.approved == nil
    end

    def media
      if object.media
        object.media.url
      end
    end
  end
end
