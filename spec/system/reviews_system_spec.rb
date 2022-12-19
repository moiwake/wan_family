require 'rails_helper'

RSpec.describe "ReviewsSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "スポットに投稿されたすべてのレビュー一覧ページ" do
    let!(:reviews) { create_list(:review, 3, :with_image, spot_id: spot.id) }
    let(:images_filenames) { reviews[0].image.files.map { |file| file.filename.to_s } }

    before { visit spot_reviews_path(spot.id) }

    it "投稿されたすべてのレビューのデータが表示される", js: true do
      reviews.each do |review|
        expect(page).to have_link("#{review.user.name}", href: spot_review_path(spot.id, review.id))
        expect(page).to have_content(review.title)
        expect(page).to have_content(review.comment)

        within("#dog-ratings#{review.id}") do
          expect(page.all(".colored").length).to eq(review.dog_score)
        end

        within("#human-ratings#{review.id}") do
          expect(page.all(".colored").length).to eq(review.human_score)
        end
      end
    end

    it "レビューに紐づく画像が、上限枚数以下で表示される" do
      reviews.each_with_index do |review, i|
        within(page.all(".review-grid-list")[i]) do
          review.image.files.length.times do |t|
            break if t == Image::MAX_IMAGE_DISPLAY_NUMBER
            expect(page.all("img")[t][:src]).to include(images_filenames[t])
          end

          expect(page.all("img").length).to be<=(Image::MAX_IMAGE_DISPLAY_NUMBER)
        end
      end
    end

    it "スポット詳細ページへのリンクがある" do
      expect(page).to have_link("#{spot.name}", href: spot_path(spot.id))
    end
  end

  describe "新規レビュー投稿ページ" do
    before do
      sign_in user
      visit spot_path(spot.id)
      click_link "レビューを投稿する"
    end

    describe "投稿ページの表示" do
      it "投稿先のスポット名が表示される" do
        expect(page).to have_content(spot.name)
      end

      it "スポット詳細ページへ戻るリンクがある" do
        expect(page).to have_link("戻る", href: spot_path(spot.id))
      end
    end

    describe "新しいレビューの投稿", js: true do
      let(:new_review) { build(:review) }
      let(:new_file_paths) { ["#{Rails.root}/spec/fixtures/images/test1.png", "#{Rails.root}/spec/fixtures/images/test2.png"] }
      let(:new_filenames) { new_file_paths.map { |new_file_path| new_file_path.split("/").last } }

      before do
        page.all(".fa-paw")[new_review.dog_score - 1].click
        page.all(".fa-star")[new_review.human_score - 1].click
        fill_in "form_review_title", with: new_review.title
        fill_in "form_review_comment", with: new_review.comment
      end

      it "アップロードするファイルを選択すると、プレビューが表示される" do
        expect do
          attach_file "form_review_image", new_file_paths
        end.to change { page.all("img").length }.by(2)
      end

      it "レビューを投稿できる" do
        expect { click_button "投稿する" }.to change { Review.count }.by(1)
        expect(Review.last.title).to eq(new_review.title)
        expect(Review.last.comment).to eq(new_review.comment)
        expect(Review.last.dog_score).to eq(new_review.dog_score)
        expect(Review.last.human_score).to eq(new_review.human_score)
      end

      it "複数の画像データを投稿できる" do
        attach_file "form_review_image", new_file_paths
        expect { click_button "投稿する" }.to change { Image.count }.by(1)

        new_filenames.each do |new_filename|
          expect(Image.last.files.blobs.pluck(:filename).include?(new_filename)).to eq(true)
        end
      end

      it "投稿後にフラッシュメッセージが表示される" do
        click_button "投稿する"
        expect(page).to have_content("新規のレビューを投稿しました。")
      end
    end
  end

  describe "レビュー詳細ページ" do
    let!(:review) { create(:review, user_id: user.id, spot_id: spot.id) }
    let!(:image) { create(:image, :attached, review_id: review.id) }
    let(:image_filenames) { review.image.files.map { |file| file.filename.to_s } }

    before { visit spot_review_path(spot.id, review.id) }

    it "レビューのデータが表示される", js: true do
      expect(page).to have_content(review.user.name)
      expect(page).to have_content(review.title)
      expect(page).to have_content(review.comment)

      within(".dog-ratings") do
        expect(page.all(".colored").length).to eq(review.dog_score)
      end

      within(".human-ratings") do
        expect(page.all(".colored").length).to eq(review.human_score)
      end
    end

    it "レビューに紐づく画像がすべて表示される" do
      review.image.files.length.times do |t|
        expect(page.all("img")[t][:src]).to include(image_filenames[t])
      end
    end

    it "レビュー一覧ページへのリンクがある" do
      expect(page).to have_link("すべてのレビュー", href: spot_reviews_path(spot.id))
    end

    it "スポット詳細ページへのリンクがある" do
      expect(page).to have_link("#{spot.name}", href: spot_path(spot.id))
    end
  end

  describe "レビュー編集ページ" do
    let!(:review) { create(:review, user_id: user.id, spot_id: spot.id) }
    let!(:image) { create(:image, :attached, review_id: review.id) }

    before do
      sign_in user
      visit mypage_path
      click_link "投稿したレビュー"
      find(".fa-pencil-square-o").click
    end

    describe "レビュー編集ページの表示", js: true do
      let(:image_filenames) { review.image.files.map { |file| file.filename.to_s } }

      it "レビューのデータが入力ページに表示される" do
        expect(find("#form_review_title").value).to eq(review.title)
        expect(find("#form_review_comment").value).to eq(review.comment)

        within(".dog-ratings") do
          expect(page.all(".colored").length).to eq(review.dog_score)
        end

        within(".human-ratings") do
          expect(page.all(".colored").length).to eq(review.human_score)
        end
      end

      it "レビューに紐づく画像が、チェックボックスの選択肢として表示される" do
        within(".check-box-delete-image") do
          review.image.files.length.times do |t|
            within(page.all("label")[t]) do
              expect(find("img")[:src]).to include(image_filenames[t])
            end
          end
        end
      end

      it "スポット詳細ページへ戻るリンクがある" do
        expect(page).to have_link("戻る", href: spot_path(spot.id))
      end
    end

    describe "レビューの更新", js: true do
      let(:updated_review) { build(:review, user_id: user.id, spot_id: spot.id) }
      let!(:remained_filenames) do
        remained_files = image.files.reject { |file| file.id == removed_file_id }
        remained_files.map { |file| file.blob.filename.to_s }
      end
      let(:added_file_path) { "#{Rails.root}/spec/fixtures/images/test3.png" }
      let(:added_filename) { added_file_path.split("/").last }
      let(:removed_file_id) { image.files.first.id }

      before do
        fill_in "form_review_title", with: updated_review.title
        fill_in "form_review_comment", with: updated_review.comment
        page.all(".fa-paw")[updated_review.dog_score - 1].click
        page.all(".fa-star")[updated_review.human_score - 1].click
        attach_file "form_review_image", added_file_path
        check "form_files_blob_ids_#{removed_file_id}"
      end

      it "レビューを更新できる" do
        expect { click_button "投稿する" }.to change { Review.count }.by(0)
        expect(review.reload.title).to eq(updated_review.title)
        expect(review.reload.comment).to eq(updated_review.comment)
        expect(review.reload.dog_score).to eq(updated_review.dog_score)
        expect(review.reload.human_score).to eq(updated_review.human_score)
        expect(review.reload.user_id).to eq(updated_review.user_id)
        expect(review.reload.spot_id).to eq(updated_review.spot_id)
      end

      it "投稿画像を追加できる" do
        expect { click_button "投稿する" }.to change { Image.count }.by(0)

        remained_filenames.each do |remained_filename|
          expect(image.reload.files.blobs.pluck(:filename).include?(remained_filename)).to eq(true)
        end

        expect(image.reload.files.blobs.pluck(:filename).include?(added_filename)).to eq(true)
      end

      it "指定した投稿画像を削除できる" do
        click_button "投稿する"
        expect(image.reload.files.blobs.pluck(:id).include?(removed_file_id)).to eq(false)
      end

      it "投稿後にフラッシュメッセージが表示される" do
        click_button "投稿する"
        expect(page).to have_content("#{spot.name}のレビューを変更しました。")
      end
    end
  end
end
