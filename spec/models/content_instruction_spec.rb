# == Schema Information
#
# Table name: content_instructions
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  description    :string           not null
#  required_media :boolean
#  content_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentInstruction, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
