FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "review_title#{n}" }
    sequence(:comment) { |n| "review_comment#{n}" }
    sequence(:dog_score) { rand(1..5) }
    sequence(:human_score) { rand(1..5) }

    trait :with_image do
      after(:create) do |review|
        image = review.build_image(user_id: review.user.id, spot_id: review.spot.id)
        image.files.attach(
          { io: File.open('spec/fixtures/images/test1.png'), filename: 'test1.png' },
          { io: File.open('spec/fixtures/images/test2.png'), filename: 'test2.png' },
          { io: File.open('spec/fixtures/images/test3.png'), filename: 'test3.png' },
          { io: File.open('spec/fixtures/images/test4.png'), filename: 'test4.png' },
          { io: File.open('spec/fixtures/images/test5.png'), filename: 'test5.png' },
          { io: File.open('spec/fixtures/images/test6.png'), filename: 'test6.png' },
        )
        image.save
      end
    end

    trait :invalid do
      title { nil }
      comment { nil }
      dog_score { nil }
      human_score { nil }
    end

    association :user
    association :spot
  end
end
