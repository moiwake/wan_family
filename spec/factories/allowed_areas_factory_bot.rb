FactoryBot.define do
  factory :allowed_area do
    sequence(:area) { |n| "area#{n}" }
  end
end
