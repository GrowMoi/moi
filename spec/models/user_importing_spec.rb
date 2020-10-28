# == Schema Information
#
# Table name: user_importings
#
#  id         :integer          not null, primary key
#  users      :json             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserImporting, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
