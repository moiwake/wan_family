option_titles = ["訪問施設の利用について", "訪問時の過ごし方", "ワンちゃんの制限", "ワンちゃんの体調・健康", "ワンちゃんのしつけ"]

option_titles.each_with_index do |t, i|
  OptionTitle.seed do |s|
    s.id = i + 1
    s.name = t
  end
end
