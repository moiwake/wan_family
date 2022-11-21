FactoryBot.define do
  factory :rule do
    answer { "0" }

    association :spot
    association :rule_option
  end
end
