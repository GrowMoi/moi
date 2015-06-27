# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  media       :string
#

FactoryGirl.define do
  factory :content do
    neuron

    level { Content::LEVELS.sample }
    kind { Content::KINDS.sample }
    sequence(:description) { |n|
      "Content's description #{n}"
    }

    trait :with_keywords do
      keyword_list {
        1.upto(10).map do |i|
          "keyword#{i}"
        end.sample(2).join(", ")
      }
    end
  end
end
