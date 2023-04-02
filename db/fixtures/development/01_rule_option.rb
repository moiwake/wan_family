rule_options = {
  "1" => ["事前に連絡・予約が必要", "会員登録が必要", "同伴可能な日時が決まっている", "ワンちゃんの利用料金あり"],
  "2" => ["マナーバンド・マナーパンツ着用", "衣服の着用", "リードの使用", "ゲージに入れる", "ペットカート・キャリーバッグ内に入れる",
          "ワンちゃん用の食器が必要", "マット・トイレシートを敷く"],
  "3" => ["小型犬のみ", "同伴する頭数に制限あり"],
  "4" => ["避妊済み・ヒート中ではない", "ワクチン接種や狂犬病接種が済んでいる"],
  "5" => ["無駄吠え・トイレなどのしつけがされている", "マーキング癖がない"],
}

OptionTitle.order(:id).ids.each do |title_id|
  rule_options[title_id.to_s].each do |opt|
    RuleOption.seed do |s|
      s.id = RuleOption.count + 1
      s.option_title_id = title_id
      s.name = opt
    end
  end
end
