FactoryBot.define do
  factory :option_title do
    sequence(:name) { |n| "option_title#{n}" }
  end
end
