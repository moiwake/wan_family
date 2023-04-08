FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "review_title#{n}" }
    sequence(:comment) { |n| "review_comment#{n}" }
    sequence(:dog_score) { rand(1..5) }
    sequence(:human_score) { rand(1..5) }
    sequence(:visit_date) { "2023-01-01" }

    trait :with_image do
      after(:create) do |review|
        image = review.build_image(user_id: review.user.id, spot_id: review.spot.id)
        image.files.attach(
          { io: File.open('spec/fixtures/images/test1.png'), filename: 'test1.png' },
          { io: File.open('spec/fixtures/images/test2.png'), filename: 'test2.png' },
        )
        image.save
      end
    end

    trait :invalid do
      title { nil }
      comment { nil }
      dog_score { nil }
      human_score { nil }
      visit_date { nil }
    end

    association :user
    association :spot
  end
end
