# == Schema Information
#
# Table name: user_importings
#
#  id         :integer          not null, primary key
#  users      :json             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserImporting < ActiveRecord::Base
end
