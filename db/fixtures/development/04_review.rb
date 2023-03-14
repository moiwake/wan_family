dummy_reviews = [
  { title: "森の中にある大きなドッグラン", comment: "大型犬、中型犬、小型犬ごとにドッグランがわかれているので、安心です。", human_score: 4, dog_score: 5 },
  { title: "愛犬３匹と散歩", comment: "とても広い公園で、犬と一緒に入れるカフェもあります。", human_score: 3, dog_score: 4 },
  { title: "ランチに", comment: "とても暑い日でしたが、お店の中でワンちゃんと一緒に食事ができるので快適でした。", human_score: 5, dog_score: 3 },
  { title: "ワンちゃんの誕生日", comment: "ワンちゃんの誕生日なので旅行に来ました。", human_score: 5, dog_score: 5 },
  { title: "コートを探しに", comment: "すごく品揃えが良く、ピッタリのコートが買えました。", human_score: 5, dog_score: 2 },
  { title: "家族旅行で", comment: "どの施設も犬と一緒に入れます。", human_score: 5, dog_score: 3 },
  { title: "犬と一緒に映画", comment: "映画は楽しめましたが、犬は退屈そうでした。", human_score: 5, dog_score: 1 },
  { title: "海が見える", comment: "海が近いきれいなレストランです。犬用のメニューもあります。", human_score: 5, dog_score: 4 },
  { title: "犬と旅行", comment: "ドッグランが付いているロッジで、犬用のディナーメニューもあります。", human_score: 5, dog_score: 5 },
  { title: "花が綺麗でした", comment: "ドッグランの隣にある花畑も散歩できます。", human_score: 4, dog_score: 4 },
]

dummy_reviews.each_with_index do |review, i|
  Review.seed do |s|
    s.user_id = i + 1
    s.spot_id = i + 1
    s.title = review[:title]
    s.comment = review[:comment]
    s.human_score = review[:human_score]
    s.dog_score = review[:dog_score]
  end
end
