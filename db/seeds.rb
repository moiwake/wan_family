# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.find_or_create_by(id: 1) do |c|
  c.name = "user01"
  c.email = "user01@email.com"
  c.password = "user01"
end

Admin.find_or_create_by(id: 1) do |c|
  c.email = "example@email.com"
  c.password = "example00"
end

categories = ["ドッグラン", "公園", "飲食店", "宿泊", "ショップ", "観光・レジャー施設", "その他"]
categories.each_with_index do |c, i|
  Category.find_or_create_by(id: i + 1, name: c)
end

allowed_areas = ["全エリア", "指定エリア（屋内・屋外）", "指定エリア（屋内のみ）", "指定エリア（屋外のみ）", "その他"]
allowed_areas.each_with_index do |c, i|
  AllowedArea.find_or_create_by(id: i + 1, area: c)
end

option_titles = ["訪問施設の利用について", "訪問時の過ごし方", "ワンちゃんの制限", "ワンちゃんの体調・健康", "ワンちゃんのしつけ", "その他のルール"]
rule_options = {
  "0" => ["事前に連絡・予約が必要", "会員登録が必要", "同伴可能な日時が決まっている", "ワンちゃんの利用料金あり"],
  "1" => ["マナーバンド・マナーパンツ着用", "衣服の着用", "リードの使用", "ゲージに入れる", "ペットカート・キャリーバッグ内に入れる",
          "ワンちゃん用の食器が必要", "マット・トイレシートを敷く"],
  "2" => ["小型犬のみ", "犬以外のペット不可・要相談", "同伴する頭数に制限あり"],
  "3" => ["避妊済み", "ヒート中は利用不可", "ワクチン接種や狂犬病接種が済んでいる"],
  "4" => ["無駄吠え・トイレなどのしつけがされている", "マーキング癖がない", "不用意に噛み付く恐れがない"],
  "5" => ["その他のルールあり"]
}

option_titles.each_with_index do |title, title_i|
  OptionTitle.find_or_create_by(id: title_i + 1, name: title)

  rule_options[title_i.to_s].each_with_index do |opt, opt_i|
    OptionTitle.find(title_i + 1).rule_option.find_or_create_by(id: 1 + RuleOption.count, name: opt)
  end
end
