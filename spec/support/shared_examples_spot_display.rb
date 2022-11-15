shared_examples "display_all_categories" do
  it "すべてのカテゴリーが表示される" do
    categories.each do |category|
      expect(response.body).to include(category.name)
    end
  end
end

shared_examples "display_all_allowed_areas" do
  it "すべての同伴可能エリアが表示される" do
    allowed_areas.each do |allowed_area|
      expect(response.body).to include(allowed_area.area)
    end
  end
end

shared_examples "display_all_option_titles" do
  it "すべての同伴条件の選択肢のタイトルが表示される" do
    option_titles.each do |option_title|
      expect(response.body).to include(option_title.name)
    end
  end
end
