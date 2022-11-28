FactoryBot.define do
  factory :review do
    user { nil }
    spot { nil }
    comment { "MyText" }
    score { 1 }
  end
end
