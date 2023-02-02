FactoryBot.define do
  factory :spot_tag do
    # name { "行きたい" }
    memo { "メモ" }
    association :user
    association :spot
  end
end
