# == Schema Information
#
# Table name: admin_achievements
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  image       :string
#  category    :string
#  number      :integer
#  active      :boolean          default(TRUE)
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :admin_achievement do
    
  end

end
