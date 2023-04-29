shared_examples "displays_all_categories" do
  it "すべてのカテゴリー名が表示される" do
    categories.each do |category|
      expect(locator).to have_content(category.name)
    end
  end
end

shared_examples "displays_all_allowed_areas" do
  it "すべての同伴可能エリアが表示される" do
    allowed_areas.each do |allowed_area|
      expect(locator).to have_content(allowed_area.area)
    end
  end
end

shared_examples "displays_all_regions" do
  it "すべての地方名が表示される" do
    regions.each_with_index do |region, i|
      expect(locator.all("optgroup")[i][:label]).to eq(region.name)
    end
  end
end

shared_examples "displays_all_prefectures" do
  it "すべての県名が表示される" do
    prefectures.each do |prefecture|
      expect(locator).to have_content(prefecture.name)
    end
  end
end


shared_examples "displays_all_option_titles" do
  it "すべての同伴ルールの選択肢のタイトルが表示される" do
    option_titles.each do |option_title|
      expect(locator).to have_content(option_title.name)
    end
  end
end

shared_examples "displays_all_rule_options" do
  it "すべての同伴ルールの選択肢が表示される" do
    rule_options.each do |rule_option|
      expect(locator).to have_content(rule_option.name)
    end
  end
end

shared_examples "displays_the_data_of_the_target_spot" do
  it "対象のスポットのデータが表示される", js: true do
    expect(page).to have_content(spot.name)
    expect(page).to have_content(spot.address)
    expect(page).to have_content(spot.category.name)
    expect(find(".favorite-count")).to have_content(spot.favorite_spots.size)
    expect(find(".review-count")).to have_content(spot.reviews.size)
    expect(all(".rating-score")[0]).to have_content(spot.reviews.average(:dog_score).round(1))
    expect(all(".rating-score")[1]).to have_content(spot.reviews.average(:human_score).round(1))

    within(all(".dog-rating")[0]) do
      expect(all(".js-colored").length).to eq(2)
      expect(all(".js-half-color").length).to eq(1)
      expect(all(".js-non-colored").length).to eq(2)
    end

    within(all(".human-rating")[0]) do
      expect(all(".js-colored").length).to eq(3)
      expect(all(".js-half-color").length).to eq(1)
      expect(all(".js-non-colored").length).to eq(1)
    end
  end
end

shared_examples "displays_the_most_helpful_reviews_posted_on_the_target_spot" do
  it "対象のスポットに投稿されたレビューのうち、最も役立ったが登録されているレビューが表示される" do
    expect(find(".review-comment")).to have_content(helpful_review.title)
    expect(find(".review-comment")).to have_content(helpful_review.comment)
  end
end

shared_examples "displays_the_top_5_liked_images_posted_on_the_target_spot" do
  it "対象のスポットに投稿された画像のうち、いいね登録数上位5個までの画像が表示される" do
    ranked_blobs_index.each_with_index do |index, i|
      expect(find(".small-image").all("img")[i][:src]).to include(blobs[index].filename.to_s)
    end
  end
end

shared_examples "displays_small_image_on_the_display_of_large_image_when_mouse_hovers_over_it" do
  it "小画像をマウスオーバーすると、大画像のディスプレイに表示される", js: true do
    find(".small-image").all("img")[0].hover
    expect(find(".large-image").find("img")[:src]).to eq(find(".small-image").all("img")[0][:src])
  end
end
