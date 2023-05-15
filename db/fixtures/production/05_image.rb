Review.count.times do |i|
  Image.seed do |s|
    s.id = i + 1
    s.review_id = i + 1
    s.user_id = i + 1
    s.spot_id = i + 1
  end
end
