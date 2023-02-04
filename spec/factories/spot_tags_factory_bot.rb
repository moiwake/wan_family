FactoryBot.define do
  factory :spot_tag do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:memo) { |n| "memo_#{n}" }

    association :user
    association :spot
  end
end
