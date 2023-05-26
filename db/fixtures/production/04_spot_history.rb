10.times do |i|
  SpotHistory.seed do |s|
    s.id = i + 1
    s.user_id = i + 1
    s.spot_id = i + 1
    s.history = "新規登録"
  end
end
