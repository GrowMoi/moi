# == Schema Information
#
# Table name: admin_achievements
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  image       :string
#  category    :string
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe AdminAchievement, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
