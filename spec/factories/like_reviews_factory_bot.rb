FactoryBot.define do
  factory :like_review do
    association :user
    association :review
  end
end
