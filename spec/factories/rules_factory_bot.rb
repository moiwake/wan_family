FactoryBot.define do
  factory :rule do
    answer { "1" }

    association :spot
    association :rule_option
  end
end
