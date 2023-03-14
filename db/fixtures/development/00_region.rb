region = [
  { name: "北海道", name_roma: "hokkaido" },
  { name: "東北", name_roma: "tohoku" },
  { name: "関東", name_roma: "kanto" },
  { name: "中部", name_roma: "chubu" },
  { name: "近畿", name_roma: "kinki" },
  { name: "中国", name_roma: "chugoku" },
  { name: "四国", name_roma: "shikoku" },
  { name: "九州", name_roma: "kyushu" },
  { name: "沖縄", name_roma: "okinawa" },
]

region.each_with_index do |region, i|
  Region.seed do |s|
    s.id = i + 1
    s.name = region[:name]
    s.name_roma = region[:name_roma]
  end
end
