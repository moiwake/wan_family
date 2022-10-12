FactoryBot.define do
  factory :admin do
    email { "admin01@email.com" }
    password { "adminpass01" }
    password_confirmation { "adminpass01" }
  end

  factory :another_admin, class: "Admin" do
    email { "another@email.com" }
    password { "anotherpass01" }
    password_confirmation { "anotherpass01" }
    user_introduction { "更新されてません" }
  end
end

