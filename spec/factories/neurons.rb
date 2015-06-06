# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :integer          default(0)
#

FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :with_parent do
      parent { create(:neuron) }
    end

    trait :inactive do
      state :deleted
    end
  end
end
