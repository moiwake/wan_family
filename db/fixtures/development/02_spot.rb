dummy_spots = [
  {
    name: "森林公園ドッグラン",
    latitude: 40.312164,
    longitude: 140.567490,
    address: "秋田県大館市釈迦内",
    official_site: "https://www.forestpark-dogrun",
    allowed_area_id: 1,
    category_id: 1,
    prefecture_id: 5,
  },
  {
    name: "ドッググリーンパーク",
    latitude: 43.732285,
    longitude: 142.351562,
    address: "北海道旭川市神居町",
    official_site: "https://www.dog-greenpark",
    allowed_area_id: 2,
    category_id: 2,
    prefecture_id: 1,
  },
  {
    name: "Cafe Dog Garden",
    latitude: 35.040970,
    longitude: 135.753998,
    address: "京都府京都市北区",
    official_site: "https://www.cafe-dog-garden",
    allowed_area_id: 3,
    category_id: 3,
    prefecture_id: 26,
  },
  {
    name: "オーシャンリゾートホテル",
    latitude: 26.223433,
    longitude: 127.682686,
    address: "沖縄県那覇市前島",
    official_site: "https://www.ocean-resort-hotel",
    allowed_area_id: 4,
    category_id: 4,
    prefecture_id: 47,
  },
  {
    name: "ペットウェアショップ",
    latitude: 35.659397,
    longitude: 139.698318,
    address: "東京都渋谷区道玄坂",
    official_site: "https://www.petwearshop",
    allowed_area_id: 1,
    category_id: 5,
    prefecture_id: 13,
  },
  {
    name: "ふれあいランド",
    latitude: 34.728992,
    longitude: 138.989227,
    address: "静岡県賀茂郡河津町浜",
    official_site: "https://www.fureailand",
    allowed_area_id: 1,
    category_id: 6,
    prefecture_id: 22,
  },
  {
    name: "ワンシネマ",
    latiude: 35.168739,
    longitude: 136.872940,
    address: "愛知県名古屋市中村区",
    official_site: "https://www.wancinema",
    allowed_area_id: 3,
    category_id: 7,
    prefecture_id: 23,
  },
  {
    name: "シーサイドドッグハウス",
    latitude: 33.582916,
    longitude: 130.323135,
    address: "福岡県福岡市西区",
    official_site: "https://www.",
    allowed_area_id: 1,
    category_id: 3,
    prefecture_id: 40,
  },
  {
    name: "ドッグロッジ",
    lattude: 33.945057,
    longitude: 133.281815,
    address: "愛媛県新居浜市滝の宮町",
    official_site: "https://www.",
    allowed_area_id: 2,
    category_id: 4,
    prefecture_id: 38,
  },
  {
    name: "フラワーパークドッグラン",
    latitude: 34.727257,
    longitude: 135.144394,
    address: "兵庫県神戸市北区",
    official_site: "https://www.",
    allowed_area_id: 2,
    category_id: 1,
    prefecture_id: 28,
  },
]

dummy_spots.each_with_index do |spot, i|
  Spot.seed do |s|
    s.id = i + 1
    s.name = spot[:name]
    s.latitude = spot[:latitude]
    s.longitude = spot[:longitude]
    s.address = spot[:address]
    s.official_site = spot[:official_site]
    s.allowed_area_id = spot[:allowed_area_id]
    s.category_id = spot[:category_id]
    s.prefecture_id = spot[:prefecture_id]
  end
end
