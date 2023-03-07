Spot.count.times do |i|
  User.seed do |s|
    s.id = i + 1
    s.name = "user#{i + 1}"
    s.email = "user#{i + 1}@email.com"
    s.password = "user#{i + 1}"
  end
end
