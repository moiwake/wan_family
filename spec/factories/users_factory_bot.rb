FactoryBot.define do
  factory :user do
    name { "user01" }
    email { "user01@email.com" }
    password { "userpass01" }
    password_confirmation { "userpass01" }

    trait :duplicated_name do
      name { "user01" }
      email { "uniqe@email.com" }
    end

    trait :duplicated_email do
      name { "uniqe_name" }
      email { "user01@email.com" }
    end
  end

  factory :another_user, class: "User" do
    name { "another_user" }
    email { "another@email.com" }
    password { "anotherpass01" }
    password_confirmation { "anotherpass01" }
    introduction { "更新されてません" }
  end
end
