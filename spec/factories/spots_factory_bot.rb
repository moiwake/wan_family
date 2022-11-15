FactoryBot.define do
  factory :spot do
    sequence(:name) { |n| "spot#{n}" }
    sequence(:latitude) { |n| n }
    sequence(:longitude) { |n| n }
    sequence(:address) { |n| "spot_address_#{n}" }
    official_site { "http://official_site" }

    trait :with_rules do
      after(:build) do |spot|
        build_list(:rule, 2, spot: spot, answer: "1")
        build_list(:rule, 2, spot: spot, answer: "0")
      end
    end

    trait :real_spot do
      name { "東京タワー" }
      latitude { 35.6585805 }
      longitude { 139.7454329 }
      address { "東京都港区芝公園４丁目２−８" }
    end

    trait :duplicated_name do
      name { "東京タワー" }
      latitude { 1.0 }
      longitude { 1.0 }
      address { "uniqe_address" }
    end

    trait :duplicated_latlng do
      name { "uniqe_name" }
      latitude { 35.6585805 }
      longitude { 139.7454329 }
      address { "uniqe_address" }
    end

    trait :duplicated_latitude do
      name { "uniqe_name" }
      latitude { 35.6585805 }
      longitude { 1.0 }
      address { "uniqe_address" }
    end

    trait :duplicated_longitude do
      name { "uniqe_name" }
      latitude { 1.0 }
      longitude { 139.7454329 }
      address { "uniqe_address" }
    end

    trait :duplicated_address do
      name { "uniqe_name" }
      latitude { 1.0 }
      longitude { 1.0 }
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
  end
end
