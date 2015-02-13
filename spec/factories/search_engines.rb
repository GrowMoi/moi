FactoryGirl.define do
  factory :search_engine do
    sequence(:name) { |n| "Search Engine #{n}" }
    sequence(:slug) {|n| "searchengine#{n}" }
    active true
    sequence(:gcse_id) {|n| "pqncoir:asd:#{n}" }
  end
end
