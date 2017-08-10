# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  image       :string
#  type        :string           not null
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Award < ActiveRecord::Base
end
