FactoryBot.define do
  factory :spot_favorite do
    association :user
    association :spot
  end
end
