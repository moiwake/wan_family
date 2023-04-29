FactoryBot.define do
  factory :spot_tag do
    sequence(:name) { |n| "#{n}_name" }
    sequence(:memo) { |n| "#{n}_memo" }

    association :user
    association :spot
  end
end
