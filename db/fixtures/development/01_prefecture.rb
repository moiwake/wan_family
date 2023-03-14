prefectures = [
  { name: "北海道", name_roma: "hokkaido", region_id: 1 },
  { name: "青森県", name_roma: "aomori", region_id: 2 },
  { name: "岩手県", name_roma: "iwate", region_id: 2 },
  { name: "宮城県", name_roma: "miyagi", region_id: 2 },
  { name: "秋田県", name_roma: "akita", region_id: 2 },
  { name: "山形県", name_roma: "yamagata", region_id: 2 },
  { name: "福島県", name_roma: "fukushima", region_id: 2 },
  { name: "茨城県", name_roma: "ibaraki", region_id: 3 },
  { name: "栃木県", name_roma: "tochigi", region_id: 3 },
  { name: "群馬県", name_roma: "gunma", region_id: 3 },
  { name: "埼玉県", name_roma: "saitama", region_id: 3 },
  { name: "千葉県", name_roma: "chiba", region_id: 3 },
  { name: "東京都", name_roma: "tokyo", region_id: 3 },
  { name: "神奈川県", name_roma: "kanagawa", region_id: 3 },
  { name: "新潟県", name_roma: "niigata", region_id: 4 },
  { name: "富山県", name_roma: "fukuyama", region_id: 4 },
  { name: "石川県", name_roma: "ishikawa", region_id: 4 },
  { name: "福井県", name_roma: "fukui", region_id: 4 },
  { name: "山梨県", name_roma: "yamanashi", region_id: 4 },
  { name: "長野県", name_roma: "nagano", region_id: 4 },
  { name: "岐阜県", name_roma: "gifu", region_id: 4 },
  { name: "静岡県", name_roma: "shizuoka", region_id: 4 },
  { name: "愛知県", name_roma: "aichi", region_id: 4 },
  { name: "三重県", name_roma: "mie", region_id: 5 },
  { name: "滋賀県", name_roma: "shiga", region_id: 5 },
  { name: "京都府", name_roma: "kyoto", region_id: 5 },
  { name: "大阪府", name_roma: "osaka", region_id: 5 },
  { name: "兵庫県", name_roma: "hyogo", region_id: 5 },
  { name: "奈良県", name_roma: "nara", region_id: 5 },
  { name: "和歌山県", name_roma: "wakayama", region_id: 5 },
  { name: "鳥取県", name_roma: "tottori", region_id: 6 },
  { name: "島根県", name_roma: "shimane", region_id: 6 },
  { name: "岡山県", name_roma: "okayama", region_id: 6 },
  { name: "広島県", name_roma: "hiroshima", region_id: 6 },
  { name: "山口県", name_roma: "yamaguchi", region_id: 6 },
  { name: "徳島県", name_roma: "tokushima", region_id: 7 },
  { name: "香川県", name_roma: "kagawa", region_id: 7 },
  { name: "愛媛県", name_roma: "ehime", region_id: 7 },
  { name: "高知県", name_roma: "kochi", region_id: 7 },
  { name: "福岡県", name_roma: "fukuoka", region_id: 8 },
  { name: "佐賀県", name_roma: "saga", region_id: 8 },
  { name: "長崎県", name_roma: "nagasaki", region_id: 8 },
  { name: "熊本県", name_roma: "kumamoto", region_id: 8 },
  { name: "大分県", name_roma: "oita", region_id: 8 },
  { name: "宮崎県", name_roma: "miyazaki", region_id: 8 },
  { name: "鹿児島県", name_roma: "kagoshima", region_id: 8 },
  { name: "沖縄県", name_roma: "okinawa", region_id: 9 },
]

prefectures.each_with_index do |prefecture, i|
  Prefecture.seed do |s|
    s.id = i + 1
    s.name = prefecture[:name]
    s.name_roma = prefecture[:name_roma]
    s.region_id = prefecture[:region_id]
  end
end
