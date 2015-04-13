# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted    :boolean          default("false")
#

FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :with_parent do
      parent { create(:neuron) }
    end

    trait :inactive do
      deleted true
    end
  end
end
