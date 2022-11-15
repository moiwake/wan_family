FactoryBot.define do
  factory :rule_option do
    sequence(:name) { |n| "rule_option#{n}" }

    association :option_title
  end
end
