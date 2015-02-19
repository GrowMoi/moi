# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :with_parent do
      parent { create(:neuron) }
    end
  end
end
