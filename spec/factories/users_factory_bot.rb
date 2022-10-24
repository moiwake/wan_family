FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "pass00" }
    password_confirmation { "pass00" }

    trait :updated_profile_user do
      introduction { "自己紹介" }
      after(:create) do |user|
        user.avatar.attach(io: File.open('spec/fixtures/images/test1.png'), filename: 'test1.jpeg', content_type: 'image/png')
      end
    end
  end
end
