shared_examples "displays_all_categories" do
  it "すべてのカテゴリーが表示される" do
    categories.each do |category|
      expect(page).to have_content(category.name)
    end
  end
end

shared_examples "displays_all_allowed_areas" do
  it "すべての同伴可能エリアが表示される" do
    allowed_areas.each do |allowed_area|
      expect(page).to have_content(allowed_area.area)
    end
  end
end

shared_examples "displays_all_option_titles" do
  it "すべての同伴ルールの選択肢のタイトルが表示される" do
    option_titles.each do |option_title|
      expect(page).to have_content(option_title.name)
    end
  end
end

shared_examples "displays_all_rule_options" do
  it "すべての同伴ルールの選択肢のタイトルが表示される" do
    rule_options.each do |rule_option|
      expect(page).to have_content(rule_option.name)
    end
  end
end
