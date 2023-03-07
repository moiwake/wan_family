categories = ["ドッグラン", "公園", "飲食店", "宿泊", "ショップ", "観光・レジャー施設", "その他"]

categories.each_with_index do |caregory, i|
  Category.seed do |s|
    s.id = i + 1
    s.name = caregory
  end
end
