FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@email.com" }
    password { "adminpass00" }
    password_confirmation { "adminpass00" }
  end

  factory :another_admin, class: "Admin" do
    email { "another@email.com" }
    password { "anotherpass01" }
    password_confirmation { "anotherpass01" }
  end
end
