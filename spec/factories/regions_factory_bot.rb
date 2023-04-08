FactoryBot.define do
  factory :region do
    sequence(:name) { |n| "region_name_#{n}" }
    sequence(:name_roma) { |n| "region_name_roma_#{n}" }

    trait :real_region do
      name { "関東" }
      name_roma { "Kanto" }
    end
  end
end
