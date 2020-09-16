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
#  in_review  :boolean
#  approved   :boolean
#  text       :string
#

module Tutor
  class SimpleRequestValidationSerializer < ActiveModel::Serializer
    root false
    attributes  :id,
                :user_id,
                :content_id,
                :media,
                :in_review,
                :text,
                :approved,
                :created_at,
                :content_title,
                :content_instruction

    def content_title
      object.content.title
    end

    def content_instruction
      if object.content.content_instruction
        Api::ContentInstructionSerializer.new(object.content.content_instruction)
      end
    end
  end
end
