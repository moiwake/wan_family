FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "pass00" }
    password_confirmation { "pass00" }


    trait :updated_profile_user do
      introduction { "自己紹介" }
      after(:create) do |user|
        user.avatar.attach(io: File.open('spec/fixtures/images/test.jpeg'), filename: 'test.jpeg', content_type: 'image/jpeg')
      end
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
