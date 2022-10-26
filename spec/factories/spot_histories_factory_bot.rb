FactoryBot.define do
  factory :spot_history do
    history { "MyString" }

    association :user
    association :spot
  end
end
