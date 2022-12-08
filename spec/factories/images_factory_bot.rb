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

    association :user
    association :spot
    association :review
  end
end
