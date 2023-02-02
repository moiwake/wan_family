FactoryBot.define do
  factory :favorite_spot do
    association :user
    association :spot
  end
end
