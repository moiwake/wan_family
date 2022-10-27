FactoryBot.define do
  factory :spot_history do
    history { "更新" }

    association :user
    association :spot
  end
end
