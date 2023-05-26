Spot.first(10).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 1
    s.spot_id = spot.id
    s.user_id = 1
  end
end

Spot.first(9).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 11
    s.spot_id = spot.id
    s.user_id = 2
  end
end

Spot.first(8).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 20
    s.spot_id = spot.id
    s.user_id = 3
  end
end

Spot.first(7).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 28
    s.spot_id = spot.id
    s.user_id = 4
  end
end

Spot.first(6).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 35
    s.spot_id = spot.id
    s.user_id = 5
  end
end

Spot.first(5).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 41
    s.spot_id = spot.id
    s.user_id = 6
  end
end

Spot.first(4).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 46
    s.spot_id = spot.id
    s.user_id = 7
  end
end

Spot.first(3).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 50
    s.spot_id = spot.id
    s.user_id = 8
  end
end

Spot.first(2).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 53
    s.spot_id = spot.id
    s.user_id = 9
  end
end

Spot.first(1).reverse_each.with_index do |spot, i|
  SpotFavorite.seed do |s|
    s.id = i + 55
    s.spot_id = spot.id
    s.user_id = 10
  end
end
