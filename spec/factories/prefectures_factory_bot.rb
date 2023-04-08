FactoryBot.define do
  factory :prefecture do
    sequence(:name) { |n| "prefecture_name_#{n}" }
    sequence(:name_roma) { |n| "prefecture_name_roma_#{n}" }

    association :region

    trait :real_prefecture do
      name { "東京都" }
      name_roma { "Tokyo" }
    end
  end
end
