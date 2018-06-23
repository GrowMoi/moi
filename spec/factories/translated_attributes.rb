# == Schema Information
#
# Table name: translated_attributes
#
#  id                :integer          not null, primary key
#  translatable_id   :integer          not null
#  translatable_type :string           not null
#  name              :string           not null
#  content           :text
#  language          :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :translated_attribute do
    sequence(:translatable_id)
    translatable_type "klass"
    name              "attr_name"
    content           "translated_content"
    language          "en"
  end
end
