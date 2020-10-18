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

FactoryGirl.define do
  factory :check_content_validation do
    
  end

end
