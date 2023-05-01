Spot.all.reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.user_id = i + 1
    s.spot_id = spot.id
  end
end
