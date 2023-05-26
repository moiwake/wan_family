10.times do |i|
  User.seed do |s|
    s.id = i + 1
    s.name = "user0#{i + 1}"
    s.email = "user0#{i + 1}@email.com"
    s.password = "user0#{i + 1}"
  end
end
