FactoryBot.define do
  factory :prefecture do
    sequence(:name) { |n| "prefecture_name_#{n}" }
    sequence(:name_roma) { |n| "prefecture_name_roma_#{n}" }

    association :region
  end
end
