FactoryBot.define do
  factory :image do
    trait :attached do
      after(:build) do |image|
        image.files.attach(
          { io: File.open('spec/fixtures/images/test1.png'), filename: 'test1.png' },
          { io: File.open('spec/fixtures/images/test2.png'), filename: 'test2.png' }
        )
      end
    end

    trait :attached_1 do
      after(:build) do |image|
        image.files.attach(
          { io: File.open('spec/fixtures/images/test3.png'), filename: 'test3.png' },
          { io: File.open('spec/fixtures/images/test4.png'), filename: 'test4.png' }
        )
      end
    end

    trait :attached_2 do
      after(:build) do |image|
        image.files.attach(
          { io: File.open('spec/fixtures/images/test5.png'), filename: 'test5.png' },
          { io: File.open('spec/fixtures/images/test6.png'), filename: 'test6.png' }
        )
      end
    end

    association :user
    association :spot
    association :review
  end
end
