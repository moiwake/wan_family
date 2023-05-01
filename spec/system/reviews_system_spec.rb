require 'rails_helper'

RSpec.describe "ReviewsSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "スポットに投稿されたレビュー一覧ページ" do
    let(:reviews) { Review.all.reverse }
    let!(:users) { create_list(:user, 3, :updated_profile_user) }

    before do
      create(:review, :with_image, user: users[0], spot: spot, dog_score: 3, human_score: 4)
      create(:review, :with_image, user: users[1], spot: spot, dog_score: 2, human_score: 4)
      create(:review, :with_image, user: users[2], spot: spot, dog_score: 3, human_score: 3)
      sign_in user
      visit spot_reviews_path(spot)
    end

    describe "レビューの表示内容" do
      it "レビューのデータが表示される", js: true do
        within(".review-list-wrap") do
          reviews.each.with_index do |review, i|
            expect(page).to have_content(review.user.name)
            expect(all(".review-header")[i].find("img")[:src]).to include(review.user.human_avatar.blob.filename.to_s)
            expect(page).to have_content(I18n.l review.visit_date, format: :short)
            expect(page).to have_content(review.title)
            expect(page).to have_content(review.comment)
            expect(page).to have_content(review.dog_score)
            expect(page).to have_content(review.human_score)
            expect(page).to have_content(I18n.l review.created_at, format: :short)

            within(all(".dog-rating")[i]) do
              expect(all(".js-colored").length).to eq(review.dog_score)
            end

            within(all(".human-rating")[i]) do
              expect(all(".js-colored").length).to eq(review.human_score)
            end
          end
        end
      end

      it "レビューに紐づく画像がすべて表示される" do
        reviews.each_with_index do |review, i|
          within(all(".review-images-wrap")[i]) do
            review.image.files_blobs.each_with_index do |blob, j|
              expect(all("img")[j][:src]).to include(blob.filename.to_s)
            end
          end
        end
      end

      it "レビューに役立ったを登録できる", js: true do
        within(all(".review-content")[0]) do
          expect do
            find(".review-helpfulness-add-btn").click
            expect(find(".review-helpfulness-btn-wrap")).to have_content(reviews[0].review_helpfulnesses.size)
          end.to change { ReviewHelpfulness.count }.by(1)

          expect(ReviewHelpfulness.last.user_id).to eq(user.id)
          expect(ReviewHelpfulness.last.review_id).to eq(reviews[0].id)
        end
      end

      it "レビューの画像を拡大表示できる", js: true do
        within(all(".review-images-wrap")[0]) do
          all("img")[0].click
          expect(page).to have_selector("#js-enlarged-image")
          expect(find("#js-enlarged-image")[:src]).to include(reviews[0].image.files_blobs[0].filename.to_s)
        end
      end
    end

    describe "レビューの表示順序" do
      shared_examples "displays_reviews_in_the_specified_order" do
        it "レビューが指定した順序で表示される" do
          ordered_reviews.each_with_index do |review, i|
            expect(all(".review-content")[i]).to have_content(review.title)
          end
        end
      end

      context "表示の順番を指定していないとき" do
        let(:ordered_reviews) { Review.all.reverse }

        it_behaves_like "displays_reviews_in_the_specified_order"
      end

      context "表示を新しい順にしたとき" do
        let(:ordered_reviews) { Review.all.reverse }

        before { click_link "新しい順" }

        it_behaves_like "displays_reviews_in_the_specified_order"
      end

      context "表示を古い順にしたとき" do
        let(:ordered_reviews) { Review.all }

        before { click_link "古い順" }

        it_behaves_like "displays_reviews_in_the_specified_order"
      end

      context "表示を役に立ったが多い順にしたとき" do
        let(:ordered_reviews) { [reviews[1], reviews[0], reviews[2]] }

        before do
          create_list(:review_helpfulness, 3, review: reviews[1])
          create_list(:review_helpfulness, 2, review: reviews[0])
          click_link "役に立ったが多い順"
        end

        it_behaves_like "displays_reviews_in_the_specified_order"
      end
    end

    describe "レビューの表示サイズ", js: true do
      context "レビューを表示する要素の高さが600px超のとき" do
        let(:height) { "400px" }
        let!(:review) { create(:review, spot: spot) }
        let!(:image) { create(:image, files: files, review: review, spot: spot) }
        let(:files) { filenames.map { |filename| fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', filename), 'image/png') } }
        let(:filenames) { ["test1.png", "test2.png", "test3.png", "test4.png", "test5.png", "test6.png"] }

        before { visit spot_reviews_path(spot) }

        include_context "resize_browser_size", 300, 1000

        it "要素の高さが指定の高さになる" do
          expect(all(".js-card")[0].style("height")["height"]).to eq(height)
        end

        it "全表示のアイコンをクリックすると、元の高さで表示される" do
          find(".fa-angles-down").click
          expect(all(".js-card")[0].style("height")["height"]).not_to eq(height)
        end
      end
    end

    describe "ページヘッダーの表示", js: true do
      it "ヘッダーに、スポットのデータが表示される" do
        expect(page).to have_content(spot.name)
        expect(page).to have_content(spot.address)
        expect(page).to have_content(spot.category.name)
        expect(page).to have_content(spot.allowed_area.area)
        expect(page).to have_content(I18n.l spot.updated_at, format: :short)
        expect(find(".favorite-count")).to have_content(spot.spot_favorites.size)
        expect(find(".review-count")).to have_content(spot.reviews.size)
        expect(all(".rating-score")[0]).to have_content(spot.reviews.average(:dog_score).round(1))
        expect(all(".rating-score")[1]).to have_content(spot.reviews.average(:human_score).round(1))

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

      it "スポット更新ページへのリンクがある" do
        expect(page).to have_link("スポットの情報を更新", href: edit_spot_path(spot))
      end

      it "スポット詳細ページへのリンクがある" do
        expect(find(".header-tabs")).to have_link("トップ", href: spot_path(spot))
      end

      it "スポットに投稿された画像一覧ページへのリンクがある" do
        expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(spot))
      end
    end

    describe "ページネーション" do
      context "表示レビューが指定個数以上のとき" do
        let(:default_per_page) { Kaminari.config.default_per_page }

        before do
          create_list(:review, default_per_page + 1, spot: spot)
          visit spot_reviews_path(spot)
        end

        it "ページ割りされる" do
          expect(find(".review-list-wrap").all(".review-content").length).to eq(default_per_page)
          expect(page).to have_selector(".pagination")
        end
      end
    end

    describe "外部の検索リンク" do
      before { visit spot_path(spot) }

      it "スポットを外部サイトで検索するリンクがある" do
        expect(page).to have_link("Googleで検索", href: "https://www.google.com/search?q=#{spot.name}")
        expect(page).to have_link("Google Mapで検索", href: "https://www.google.co.jp/maps?q=#{spot.name}")
        expect(page).to have_link("Instagramで検索", href: "https://www.instagram.com/explore/tags/#{spot.name}")
        expect(page).to have_link("Twitterで検索", href: "https://twitter.com/search?q=#{spot.name}")
      end
    end
  end

  describe "新規レビュー投稿ページ" do
    before do
      sign_in user
      visit spot_reviews_path(spot)
      click_link "レビューを投稿する"
    end

    describe "投稿ページの表示" do
      it "投稿先のスポット名が表示される" do
        expect(page).to have_content(spot.name)
      end

      it "スポットのレビュー一覧ページへ戻るリンクがある" do
        expect(page).to have_link("戻る", href: spot_reviews_path(spot))
      end
    end

    describe "新しいレビューの投稿", js: true do
      let(:new_review) { build(:review) }
      let(:new_file_paths) { new_filenames.map { |filename| "#{Rails.root}/spec/fixtures/images/#{filename}" } }
      let(:new_filenames) { ["test1.png", "test2.png"] }

      before do
        fill_in "review_title_input", with: new_review.title
        fill_in "review_comment_input", with: new_review.comment
        fill_in "review_visit_date_input", with: new_review.visit_date
        all(".fa-paw")[new_review.dog_score - 1].click
        all(".fa-star")[new_review.human_score - 1].click
      end

      it "アップロードするファイルを選択すると、プレビューが表示される" do
        expect do
          attach_file "review_image_input", new_file_paths, make_visible: true
        end.to change { find("#js-preview-image-list", visible: false).all("img").length }.by(2)
      end

      it "レビューを投稿できる" do
        expect { click_button "投稿する" }.to change { Review.count }.by(1)
        expect(Review.last.title).to eq(new_review.title)
        expect(Review.last.comment).to eq(new_review.comment)
        expect(Review.last.dog_score).to eq(new_review.dog_score)
        expect(Review.last.human_score).to eq(new_review.human_score)
        expect(Review.last.visit_date).to eq(new_review.visit_date)
      end

      it "複数の画像データを投稿できる" do
        attach_file "review_image_input", new_file_paths, make_visible: true
        expect { click_button "投稿する" }.to change { Image.count }.by(1)

        new_filenames.each_with_index do |filename, i|
          expect(Image.last.files_blobs[i].filename).to eq(filename)
        end
      end

      it "投稿後にフラッシュメッセージが表示される" do
        click_button "投稿する"
        expect(page).to have_content("レビューを投稿しました。")
      end
    end
  end

  describe "レビュー更新ページ" do
    let!(:review) { create(:review, user: user, spot: spot) }
    let!(:image) { create(:image, :attached, review: review) }

    before do
      sign_in user
      visit users_mypage_review_index_path
      find(".review-edit-btn").click
    end

    describe "レビュー更新ページの表示", js: true do
      let(:filenames) { review.image.files.map { |file| file.filename.to_s }.reverse }

      it "投稿先のスポット名が表示される" do
        expect(page).to have_content(spot.name)
      end

      it "ユーザー投稿レビュー一覧ページへ戻るリンクがある" do
        expect(page).to have_link("戻る", href: users_mypage_review_index_path)
      end

      it "レビューのデータが入力欄に表示される" do
        expect(find("#review_title_input").value).to eq(review.title)
        expect(find("#review_comment_input").value).to eq(review.comment)
        expect(all(".rating-score")[0].text).to eq(review.dog_score.to_s)
        expect(all(".rating-score")[1].text).to eq(review.human_score.to_s)
        expect(find("#review_visit_date_input").value).to eq(review.visit_date.to_s)

        within(".dog-rating") do
          expect(all(".js-colored").length).to eq(review.dog_score)
        end

        within(".human-rating") do
          expect(all(".js-colored").length).to eq(review.human_score)
        end
      end

      it "レビューに紐づく画像が、画像削除の選択肢として表示される" do
        within(".image-delete-list-wrap") do
          review.image.files_blobs.each_with_index do |blob, i|
            within(all(".image-delete-wrap")[i]) do
              expect(find("img")[:src]).to include(filenames[i])
            end
          end
        end
      end
    end

    describe "レビューの更新", js: true do
      let(:updated_review) { build(:review, user: user, spot: spot) }
      let!(:remained_filenames) do
        remained_files = image.files.reject { |file| file.id == removed_file_id }
        remained_files.map { |file| file.blob.filename.to_s }
      end
      let(:added_file_path) { "#{Rails.root}/spec/fixtures/images/#{added_filename}" }
      let(:added_filename) { "test3.png" }
      let(:removed_file_id) { image.files[0].id }

      before do
        fill_in "review_title_input", with: updated_review.title
        fill_in "review_comment_input", with: updated_review.comment
        fill_in "review_visit_date_input", with: updated_review.visit_date
        all(".fa-paw")[updated_review.dog_score - 1].click
        all(".fa-star")[updated_review.human_score - 1].click
        attach_file "review_image_input", added_file_path, make_visible: true
        check "file_id_#{removed_file_id}_input"
      end

      it "レビューを更新できる" do
        expect { click_button "投稿する" }.to change { Review.count }.by(0)
        expect(review.reload.title).to eq(updated_review.title)
        expect(review.reload.comment).to eq(updated_review.comment)
        expect(review.reload.visit_date).to eq(updated_review.visit_date)
        expect(review.reload.dog_score).to eq(updated_review.dog_score)
        expect(review.reload.human_score).to eq(updated_review.human_score)
        expect(review.reload.user_id).to eq(updated_review.user_id)
        expect(review.reload.spot_id).to eq(updated_review.spot_id)
      end

      it "投稿画像を追加できる" do
        expect { click_button "投稿する" }.to change { Image.count }.by(0)

        remained_filenames.each_with_index do |remained_filename, i|
          expect(image.reload.files.blobs[i].filename).to eq(remained_filename)
        end

        expect(image.reload.files_blobs.pluck(:filename).include?(added_filename)).to eq(true)
      end

      it "指定した投稿画像を削除できる" do
        click_button "投稿する"
        expect(image.reload.files_blobs.ids.include?(removed_file_id)).to eq(false)
      end

      it "投稿後にフラッシュメッセージが表示される" do
        click_button "投稿する"
        expect(page).to have_content("#{spot.name}のレビューを変更しました。")
      end
    end
  end
end
