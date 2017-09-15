# == Schema Information
#
# Table name: achievements
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  label       :string           not null
#  description :text
#  image       :string
#  category    :string           not null
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :achievement do
    name "Test"
    label "Test"
    category "test"
    settings {
      {
        learn_all_contents: false,
        quantity: nil
      }
    }
  end
end
