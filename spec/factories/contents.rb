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
#  approved    :boolean          default(FALSE)
#  title       :string
#

FactoryGirl.define do
  factory :content do
    neuron

    level do Content::LEVELS.sample end
    kind do Content::KINDS.sample end
    sequence(:description) { |n|
      "Content's description #{n}"
    }
    sequence(:source) { |n|
      "Content's source #{n}"
    }
    trait :with_keywords do
      keyword_list {
        1.upto(10).map do |i|
          "keyword#{i}"
        end.sample(2).join(", ")
      }
    end
    trait :approved do
      after(:create) do |content|
        content.update! approved: true
        content.neuron.reload.touch
      end
    end
  end
end
