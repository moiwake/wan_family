Spot.count.times do |i|
  User.seed do |s|
    s.id = i + 1
    s.name = "user_#{i + 1}"
    s.email = "user_#{i + 1}@email.com"
    s.password = "user_#{i + 1}"
  end
end
