FactoryBot.define do
  factory :image_like do
    association :user
    association :image
  end
end
