FactoryBot.define do
  factory :impression do
    impressionable_type { "Spot" }
    controller_name { "spots" }
    action_name { "show" }
    request_hash { "abcd" }
    ip_address { "ip_address" }
    session_hash { "efgh" }
    referrer { "http://localhost:3000/" }
    params { {} }

    association :impressionable, factory: :spot
  end
end

