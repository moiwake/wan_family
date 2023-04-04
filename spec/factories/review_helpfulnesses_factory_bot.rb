FactoryBot.define do
  factory :review_helpfulness do
    association :user
    association :review
  end
end
