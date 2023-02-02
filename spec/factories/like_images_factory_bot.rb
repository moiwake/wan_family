FactoryBot.define do
  factory :like_image do
    association :user
    association :image
  end
end
