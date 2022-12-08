FactoryBot.define do
  factory :prefecture do
    region { "region" }
    sequence(:name) { |n| "name#{n}" }
  end
end
