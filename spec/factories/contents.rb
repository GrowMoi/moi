# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :integer          not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :content do
    neuron

    level { Content::LEVELS.sample }
    kind { Content::KINDS.sample }
    sequence(:description) { |n|
      "Content's description #{n}"
    }
  end
end
