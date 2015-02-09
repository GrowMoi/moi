FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :with_parent do
      parent { create(:neuron) }
    end
  end
end
