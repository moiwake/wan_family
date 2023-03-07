categories = ["ドッグラン", "公園", "飲食店", "宿泊", "ショップ", "観光・レジャー施設", "その他"]
categories.each_with_index do |c, i|
  Category.find_or_create_by(id: i + 1, name: c)
end
