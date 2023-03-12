prefectures = [
  {id: 1, name: "北海道", name_roma: "hokkaido", region: "北海道", region_roma: "hokkaido"},
  {id: 2, name: "青森県", name_roma: "aomori", region: "東北", region_roma: "tohoku"},
  {id: 3, name: "岩手県", name_roma: "iwate", region: "東北", region_roma: "tohoku"},
  {id: 4, name: "宮城県", name_roma: "miyagi", region: "東北", region_roma: "tohoku"},
  {id: 5, name: "秋田県", name_roma: "akita", region: "東北", region_roma: "tohoku"},
  {id: 6, name: "山形県", name_roma: "yamagata", region: "東北", region_roma: "tohoku"},
  {id: 7, name: "福島県", name_roma: "fukushima", region: "東北", region_roma: "tohoku"},
  {id: 8, name: "茨城県", name_roma: "ibaraki", region: "関東", region_roma: "kanto"},
  {id: 9, name: "栃木県", name_roma: "tochigi", region: "関東", region_roma: "kanto"},
  {id: 10, name: "群馬県", name_roma: "gunma", region: "関東", region_roma: "kanto"},
  {id: 11, name: "埼玉県", name_roma: "saitama", region: "関東", region_roma: "kanto"},
  {id: 12, name: "千葉県", name_roma: "chiba", region: "関東", region_roma: "kanto"},
  {id: 13, name: "東京都", name_roma: "tokyo", region: "関東", region_roma: "kanto"},
  {id: 14, name: "神奈川県", name_roma: "kanagawa", region: "関東", region_roma: "kanto"},
  {id: 15, name: "新潟県", name_roma: "niigata", region: "中部", region_roma: "chubu"},
  {id: 16, name: "富山県", name_roma: "fukuyama", region: "中部", region_roma: "chubu"},
  {id: 17, name: "石川県", name_roma: "ishikawa", region: "中部", region_roma: "chubu"},
  {id: 18, name: "福井県", name_roma: "fukui", region: "中部", region_roma: "chubu"},
  {id: 19, name: "山梨県", name_roma: "yamanashi", region: "中部", region_roma: "chubu"},
  {id: 20, name: "長野県", name_roma: "nagano", region: "中部", region_roma: "chubu"},
  {id: 21, name: "岐阜県", name_roma: "gifu", region: "中部", region_roma: "chubu"},
  {id: 22, name: "静岡県", name_roma: "shizuoka", region: "中部", region_roma: "chubu"},
  {id: 23, name: "愛知県", name_roma: "aichi", region: "中部", region_roma: "chubu"},
  {id: 24, name: "三重県", name_roma: "mie", region: "近畿", region_roma: "kinki"},
  {id: 25, name: "滋賀県", name_roma: "shiga", region: "近畿", region_roma: "kinki"},
  {id: 26, name: "京都府", name_roma: "kyoto", region: "近畿", region_roma: "kinki"},
  {id: 27, name: "大阪府", name_roma: "osaka", region: "近畿", region_roma: "kinki"},
  {id: 28, name: "兵庫県", name_roma: "hyogo", region: "近畿", region_roma: "kinki"},
  {id: 29, name: "奈良県", name_roma: "nara", region: "近畿", region_roma: "kinki"},
  {id: 30, name: "和歌山県", name_roma: "wakayama", region: "近畿", region_roma: "kinki"},
  {id: 31, name: "鳥取県", name_roma: "tottori", region: "中国", region_roma: "chugoku"},
  {id: 32, name: "島根県", name_roma: "shimane", region: "中国", region_roma: "chugoku"},
  {id: 33, name: "岡山県", name_roma: "okayama", region: "中国", region_roma: "chugoku"},
  {id: 34, name: "広島県", name_roma: "hiroshima", region: "中国", region_roma: "chugoku"},
  {id: 35, name: "山口県", name_roma: "yamaguchi", region: "中国", region_roma: "chugoku"},
  {id: 36, name: "徳島県", name_roma: "tokushima", region: "四国", region_roma: "shikoku"},
  {id: 37, name: "香川県", name_roma: "kagawa", region: "四国", region_roma: "shikoku"},
  {id: 38, name: "愛媛県", name_roma: "ehime", region: "四国", region_roma: "shikoku"},
  {id: 39, name: "高知県", name_roma: "kochi", region: "四国", region_roma: "shikoku"},
  {id: 40, name: "福岡県", name_roma: "fukuoka", region: "九州", region_roma: "kyushu"},
  {id: 41, name: "佐賀県", name_roma: "saga", region: "九州", region_roma: "kyushu"},
  {id: 42, name: "長崎県", name_roma: "nagasaki", region: "九州", region_roma: "kyushu"},
  {id: 43, name: "熊本県", name_roma: "kumamoto", region: "九州", region_roma: "kyushu"},
  {id: 44, name: "大分県", name_roma: "oita", region: "九州", region_roma: "kyushu"},
  {id: 45, name: "宮崎県", name_roma: "miyazaki", region: "九州", region_roma: "kyushu"},
  {id: 46, name: "鹿児島県", name_roma: "kagoshima", region: "九州", region_roma: "kyushu"},
  {id: 47, name: "沖縄県", name_roma: "okinawa", region: "沖縄", region_roma: "okinawa"},
]

prefectures.each_with_index do |prefecture, i|
  Prefecture.seed do |s|
    s.id = i + 1
    s.name = prefecture[:name]
    s.name_roma = prefecture[:name_roma]
    s.region = prefecture[:region]
    s.region_roma = prefecture[:region_roma]
  end
end
