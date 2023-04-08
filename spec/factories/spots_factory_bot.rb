FactoryBot.define do
  factory :spot do
    sequence(:name) { |n| "spot_name_#{n}" }
    sequence(:latitude) { |n| n }
    sequence(:longitude) { |n| n }
    sequence(:address) { |n| "spot_address_#{n}" }
    sequence(:official_site) { |n| "http://official_site_#{n}" }

    trait :with_rules do
      after(:create) do |spot|
        create_list(:rule, 2, answer: "1", spot: spot)
        create_list(:rule, 2, answer: "0", spot: spot)
      end
    end

    trait :real_spot do
      name { "東京タワー" }
      latitude { 35.6585805 }
      longitude { 139.7454329 }
      address { "東京都港区芝公園４丁目２−８" }
    end

    trait :invalid_spot do
      name { nil }
      latitude { nil }
      longitude { nil }
      address { nil }
    end

    association :category
    association :allowed_area
    association :prefecture
  end
end
