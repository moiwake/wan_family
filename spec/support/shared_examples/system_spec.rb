shared_examples "カテゴリー名の表示" do
  it "すべてのカテゴリー名が表示される" do
    categories.each do |category|
      expect(locator).to have_content(category.name)
    end
  end
end

shared_examples "同伴可能エリアの表示" do
  it "すべての同伴可能エリアが表示される" do
    allowed_areas.each do |allowed_area|
      expect(locator).to have_content(allowed_area.area)
    end
  end
end

shared_examples "地方名の表示" do
  it "すべての地方名が表示される" do
    regions.each_with_index do |region, i|
      expect(locator.all("optgroup")[i][:label]).to eq(region.name)
    end
  end
end

shared_examples "県名の表示" do
  it "すべての県名が表示される" do
    prefectures.each do |prefecture|
      expect(locator).to have_content(prefecture.name)
    end
  end
end

shared_examples "ルール選択肢のタイトルの表示" do
  it "すべての同伴ルールの選択肢のタイトルが表示される" do
    option_titles.each do |option_title|
      expect(locator).to have_content(option_title.name)
    end
  end
end

shared_examples "ルール選択肢の表示" do
  it "すべての同伴ルールの選択肢が表示される" do
    rule_options.each do |rule_option|
      expect(locator).to have_content(rule_option.name)
    end
  end
end

shared_examples "対象スポットのデータの表示" do
  it "対象のスポットのデータが表示される", js: true do
    expect(page).to have_content(spot.name)
    expect(page).to have_content(spot.address)
    expect(page).to have_content(spot.category.name)
    expect(find(".favorite-count")).to have_content(spot.spot_favorites.size)
    expect(find(".review-count")).to have_content(spot.reviews.size)
    expect(find(".view-count")).to have_content(spot.impressions_count)
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

shared_examples "対象のスポットのレビューの表示" do
  it "対象のスポットに投稿されたレビューのうち、最も役立ったが登録されているレビューが表示される" do
    expect(find(".review-comment")).to have_content(helpful_review.title)
    expect(find(".review-comment")).to have_content(helpful_review.comment)
  end
end

shared_examples "対象のスポットの画像の表示" do
  it "対象のスポットに投稿された画像のうち、いいね登録数上位5個までの画像が表示される" do
    ranked_blobs_index.each_with_index do |index, i|
      expect(find(".small-image").all("img")[i][:src]).to include(blobs[index].filename.to_s)
    end
  end
end

shared_examples "マウスオーバーによる大きい画像の表示" do
  it "小画像をマウスオーバーすると、大画像のディスプレイに表示される", js: true do
    find(".small-image").all("img")[0].hover
    expect(find(".large-image").find("img")[:src]).to eq(find(".small-image").all("img")[0][:src])
  end
end

shared_examples "ページヘッダーの表示" do
  let(:target_spot) { create(:spot) }

  before do
    create(:review, dog_score: 3, human_score: 4, spot: target_spot)
    create(:review, dog_score: 2, human_score: 4, spot: target_spot)
    create(:review, dog_score: 3, human_score: 3, spot: target_spot)
    create_list(:spot_favorite, 2, spot: target_spot)
    visit send(path, target_spot)
  end

  it "ページのヘッダーに、スポットのデータが表示される", js: true do
    expect(page).to have_content(target_spot.name)
    expect(page).to have_content(target_spot.address)
    expect(page).to have_content(target_spot.category.name)
    expect(page).to have_content(target_spot.allowed_area.area)
    expect(page).to have_content(I18n.l(target_spot.updated_at, format: :short))
    expect(find(".favorite-count")).to have_content(target_spot.spot_favorites.size)
    expect(find(".review-count")).to have_content(target_spot.reviews.size)
    expect(find(".view-count")).to have_content(target_spot.reload.impressions_count)
    expect(all(".rating-score")[0]).to have_content(target_spot.reviews.average(:dog_score).round(1))
    expect(all(".rating-score")[1]).to have_content(target_spot.reviews.average(:human_score).round(1))

    within(all(".dog-rating")[0]) do
      expect(all(".js-colored").length).to eq(2)
      expect(all(".js-seven-tenths-color").length).to eq(1)
      expect(all(".js-non-colored").length).to eq(2)
    end

    within(all(".human-rating")[0]) do
      expect(all(".js-colored").length).to eq(3)
      expect(all(".js-seven-tenths-color").length).to eq(1)
      expect(all(".js-non-colored").length).to eq(1)
    end
  end

  it "ページのヘッダーにスポット更新ページへのリンクがある" do
    expect(page).to have_link("スポットの情報を更新", href: edit_spot_path(target_spot))
  end
end

shared_examples "スポット詳細ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_path(target_spot) }

  it "スポットに投稿された画像一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(target_spot))
  end

  it "スポットに投稿されたレビュー一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("レビュー", href: spot_reviews_path(target_spot))
  end
end

shared_examples "画像一覧ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_images_path(target_spot) }

  it "スポット詳細ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("トップ", href: spot_path(target_spot))
  end

  it "スポットに投稿されたレビュー一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("レビュー", href: spot_reviews_path(target_spot))
  end
end

shared_examples "レビュー一覧ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_reviews_path(target_spot) }

  it "スポット詳細ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("トップ", href: spot_path(target_spot))
  end

  it "スポットに投稿された画像一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(target_spot))
  end
end
