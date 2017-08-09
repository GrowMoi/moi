# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  image       :string
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Award < ActiveRecord::Base
end
