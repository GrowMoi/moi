# == Schema Information
#
# Table name: request_content_media_validations
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  media      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RequestContentMediaValidation < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
end
