FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@email.com" }
    password { "adminpass00" }
    password_confirmation { "adminpass00" }
  end
end
