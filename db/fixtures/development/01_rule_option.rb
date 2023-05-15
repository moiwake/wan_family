rule_options = [
  { name: "事前に連絡・予約が必要", option_title_id: 1 },
  { name: "会員登録が必要", option_title_id: 1 },
  { name: "同伴可能な日時が決まっている", option_title_id: 1 },
  { name: "ワンちゃんの利用料金あり", option_title_id: 1 },
  { name: "マナーバンド・マナーパンツ着用", option_title_id: 2 },
  { name: "衣服の着用", option_title_id: 2 },
  { name: "リードの使用", option_title_id: 2 },
  { name: "ゲージに入れる", option_title_id: 2 },
  { name: "ペットカート・キャリーバッグ内に入れる", option_title_id: 2 },
  { name: "ワンちゃん用の食器が必要", option_title_id: 2 },
  { name: "マット・トイレシートを敷く", option_title_id: 2 },
  { name: "小型犬のみ", option_title_id: 3 },
  { name: "同伴する頭数に制限あり", option_title_id: 3 },
  { name: "避妊済み・ヒート中ではない", option_title_id: 4 },
  { name: "ワクチン接種や狂犬病接種が済んでいる", option_title_id: 4 },
  { name: "無駄吠え・トイレなどのしつけがされている", option_title_id: 5 },
  { name: "マーキング癖がない", option_title_id: 5 },
]

rule_options.each_with_index do |opt, i|
  RuleOption.seed do |s|
    s.id = i + 1
    s.option_title_id = opt[:option_title_id]
    s.name = opt[:name]
  end
end
