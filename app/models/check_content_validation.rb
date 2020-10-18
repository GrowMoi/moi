# == Schema Information
#
# Table name: check_content_validations
#
#  id                            :integer          not null, primary key
#  reviewer_id                   :integer          not null
#  request_content_validation_id :integer          not null
#  approved                      :boolean          default(FALSE), not null
#  message                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class CheckContentValidation < ActiveRecord::Base
  belongs_to :reviewer, class_name: "User"
  belongs_to :request_content_validation
  validates :request_content_validation_id, uniqueness: true
end
