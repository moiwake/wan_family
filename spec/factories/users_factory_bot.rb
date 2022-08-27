FactoryBot.define do
  factory :user do
    user_name { "user01" }
    email { "user01@email.com" }
    password { "userpass01" }
    password_confirmation { "userpass01" }

    trait :duplicate_user_name do
      user_name { "user01" }
      email { "uniqe@email.com" }
    end

    trait :duplicate_email do
      user_name { "uniqe_name" }
      email { "user01@email.com" }
    end
  end

  factory :another_user, class: "User" do
    user_name { "another_user" }
    email { "another@email.com" }
    password { "anotherpass01" }
    password_confirmation { "anotherpass01" }
    user_introduction { "更新されてません" }
  end
end
