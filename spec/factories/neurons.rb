# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :active do
      active true
    end
    trait :inactive do
      active false
    end
    trait :deleted do
      deleted true
    end

    trait :with_parent do
      parent { create(:neuron) }
    end
  end
end
