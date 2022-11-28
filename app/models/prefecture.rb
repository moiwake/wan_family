class Prefecture < ActiveHash::Base
  self.data = [
    {id: 1, region: "北海道", name: "北海道"}, {id: 2, region: "東北", name: "青森県"}, {id: 3, region: "東北", name: "岩手県"},
    {id: 4, region: "東北", name: "宮城県"}, {id: 5, region: "東北", name: "秋田県"}, {id: 6, region: "東北", name: "山形県"},
    {id: 7, region: "東北", name: "福島県"}, {id: 8, region: "関東", name: "茨城県"}, {id: 9, region: "関東", name: "栃木県"},
    {id: 10, region: "関東", name: "群馬県"}, {id: 11, region: "関東", name: "埼玉県"}, {id: 12, region: "関東", name: "千葉県"},
    {id: 13, region: "関東", name: "東京都"}, {id: 14, region: "関東", name: "神奈川県"}, {id: 15, region: "中部", name: "新潟県"},
    {id: 16, region: "中部", name: "富山県"}, {id: 17, region: "中部", name: "石川県"}, {id: 18, region: "中部", name: "福井県"},
    {id: 19, region: "中部", name: "山梨県"}, {id: 20, region: "中部", name: "長野県"}, {id: 21, region: "中部", name: "岐阜県"},
    {id: 22, region: "中部", name: "静岡県"}, {id: 23, region: "中部", name: "愛知県"}, {id: 24, region: "近畿", name: "三重県"},
    {id: 25, region: "近畿", name: "滋賀県"}, {id: 26, region: "近畿", name: "京都府"}, {id: 27, region: "近畿", name: "大阪府"},
    {id: 28, region: "近畿", name: "兵庫県"}, {id: 29, region: "近畿", name: "奈良県"}, {id: 30, region: "近畿", name: "和歌山県"},
    {id: 31, region: "中国", name: "鳥取県"}, {id: 32, region: "中国", name: "島根県"}, {id: 33, region: "中国", name: "岡山県"},
    {id: 34, region: "中国", name: "広島県"}, {id: 35, region: "中国", name: "山口県"}, {id: 36, region: "四国", name: "徳島県"},
    {id: 37, region: "四国", name: "香川県"}, {id: 38, region: "四国", name: "愛媛県"}, {id: 39, region: "四国", name: "高知県"},
    {id: 40, region: "九州", name: "福岡県"}, {id: 41, region: "九州", name: "佐賀県"}, {id: 42, region: "九州", name: "長崎県"},
    {id: 43, region: "九州", name: "熊本県"}, {id: 44, region: "九州", name: "大分県"}, {id: 45, region: "九州", name: "宮崎県"},
    {id: 46, region: "九州", name: "鹿児島県"}, {id: 47, region: "沖縄", name: "沖縄県"}
  ]

  scope :find_prefecture_name, ->(region) { Prefecture.where(region: region).pluck(:name) }
end
