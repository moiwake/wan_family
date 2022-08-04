FactoryBot.define do
  factory :user do
    user_name { "pochi" }
    email { "pochi@email.com" }
    password { "abc012" }

    trait :duplicate_user_name do
      user_name { "pochi" }
      email { "uniqe@email.com" }
    end

    trait :duplicate_email do
      user_name { "uniqe_name" }
      email { "pochi@email.com" }
    end
  end
end
