# == Schema Information
#
# Table name: content_approved_by_tutors
#
#  id         :integer          not null, primary key
#  tutor_id   :integer          not null
#  user_id    :integer          not null
#  content_id :integer          not null
#  approved   :boolean          default(TRUE), not null
#  message    :string
#  media      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentApprovedByTutor, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
