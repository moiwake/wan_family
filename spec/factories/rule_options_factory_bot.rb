FactoryBot.define do
  factory :rule_option do
    name { "MyString" }

    association :option_title
  end
end
