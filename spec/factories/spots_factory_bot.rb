FactoryBot.define do
  factory :spot do
    name { "東京タワー" }
    latitude { 35.6585805 }
    longitude { 139.7454329 }
    address { "東京都港区芝公園４丁目２−８" }

    trait :duplicated_latlng do
      latitude { 35.6585805 }
      longitude { 139.7454329 }
      address { "Uniqe" }
    end

    trait :duplicated_latitude do
      latitude { 35.6585805 }
      longitude { 1.0 }
      address { "Uniqe" }
    end

    trait :duplicated_longitude do
      latitude { 1.0 }
      longitude { 139.7454329 }
      address { "Uniqe" }
    end

    trait :duplicated_address do
      latitude { 1.0 }
      longitude { 1.0 }
      address { "東京都港区芝公園４丁目２−８" }
    end

    association :category
    association :allowed_area
  end
end
