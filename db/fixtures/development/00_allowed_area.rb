allowed_areas = ["全エリア", "指定エリア（屋内・屋外）", "指定エリア（屋内のみ）", "指定エリア（屋外のみ）", "その他"]

allowed_areas.each_with_index do |area, i|
  AllowedArea.seed do |s|
    s.id = i + 1
    s.area = area
  end
end
