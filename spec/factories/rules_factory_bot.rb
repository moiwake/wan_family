FactoryBot.define do
  factory :rule do
    answer { "0" }

    trait :attached_rule_answer do
      answer { "1" }
    end

    trait :unattached_rule_answer do
      answer { "0" }
    end

    association :spot
    association :rule_option
  end
end
