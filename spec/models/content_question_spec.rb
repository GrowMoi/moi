# == Schema Information
#
# Table name: content_questions
#
#  id         :integer          not null, primary key
#  question   :string
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentQuestion, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
