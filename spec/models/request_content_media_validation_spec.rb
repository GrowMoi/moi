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

require 'rails_helper'

RSpec.describe RequestContentMediaValidation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
