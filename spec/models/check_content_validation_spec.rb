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

require 'rails_helper'

RSpec.describe CheckContentValidation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
