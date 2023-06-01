shared_context "ページヘッダーの表示" do |path|
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

shared_context "スポット詳細ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_path(target_spot) }

  it "スポットに投稿された画像一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(target_spot))
  end

  it "スポットに投稿されたレビュー一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("レビュー", href: spot_reviews_path(target_spot))
  end
end

shared_context "画像一覧ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_images_path(target_spot) }

  it "スポット詳細ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("トップ", href: spot_path(target_spot))
  end

  it "スポットに投稿されたレビュー一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("レビュー", href: spot_reviews_path(target_spot))
  end
end

shared_context "レビュー一覧ページのページヘッダーのタブ" do
  let(:target_spot) { create(:spot) }

  before { visit spot_reviews_path(target_spot) }

  it "スポット詳細ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("トップ", href: spot_path(target_spot))
  end

  it "スポットに投稿された画像一覧ページへのリンクがある" do
    expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(target_spot))
  end
end
