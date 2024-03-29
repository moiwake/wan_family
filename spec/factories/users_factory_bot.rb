FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password00" }
    password_confirmation { "password00" }

    trait :updated_profile_user do
      introduction { "introduction" }

      after(:create) do |user|
        user.human_avatar.attach(io: File.open('spec/fixtures/images/avatar1.png'), filename: 'avatar1.png', content_type: 'image/png')
        user.dog_avatar.attach(io: File.open('spec/fixtures/images/avatar2.png'), filename: 'avatar2.png', content_type: 'image/png')
      end
    end
  end
end
