require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system do
  let!(:user) { create(:user) }

  describe "お気に入り登録したスポット一覧ページ" do
    describe "お気に入り登録したスポットの表示" do
      describe "スポットのデータ" do
        let!(:spot) { create(:spot) }
        let(:helpful_review) { Review.last }
        let(:blobs) { ActiveStorage::Blob.all }
        let(:ranked_blobs_index) { [3, 1, 0, 2] }

        before do
          create(:spot_favorite, spot: spot, user: user)
          create(:review, dog_score: 3, human_score: 4, spot: spot)
          create(:review, dog_score: 2, human_score: 3, spot: spot)
          create_list(:review_helpfulness, 1, review: helpful_review)
          create(:image, :attached, spot: spot, review: helpful_review)
          create(:image, :attached_1, spot: spot, review: Review.first)
          create(:image, :attached_2, spot: spot, review: Review.first)

          ranked_blobs_index.each_with_index do |index, i|
            create_list(:image_like, (5 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
          end

          sign_in user
          visit root_path
          click_link "マイページ"
        end

        it "タグをつけたスポット一覧ページヘのリンクがある" do
          expect(page).to have_link("タグをつけたスポット", href: users_mypage_spot_tag_index_path)
        end

        it_behaves_like "対象スポットのデータの表示"
        it_behaves_like "対象のスポットのレビューの表示"
        it_behaves_like "対象のスポットの画像の表示"
        it_behaves_like "マウスオーバーによる大きい画像の表示"
      end

      describe "スポットの表示順序" do
        let!(:spots) { create_list(:spot, 3) }
        let(:ordered_spots) { [spots[2], spots[0], spots[1]] }

        before do
          ordered_spots.each do |spot|
            create(:spot_favorite, spot: spot, user: user)
          end

          sign_in user
          visit root_path
          click_link "マイページ"
        end

        it "スポットがお気に入りに登録した日の降順で表示される" do
          ordered_spots.reverse.each_with_index do |spot, i|
            expect(all(".list-content")[i]).to have_content(spot.name)
          end
        end
      end

      describe "ページネーション" do
        context "表示スポットが指定個数以上のとき" do
          let(:default_per_page) { Kaminari.config.default_per_page }

          before do
            create_list(:spot_favorite, default_per_page + 1, user: user)
            sign_in user
            visit users_mypage_spot_favorite_index_path
          end

          it "ページ割りされる" do
            expect(find(".spot-list-wrap").all(".list-content").length).to eq(default_per_page)
            expect(page).to have_selector(".pagination")
          end
        end
      end
    end

    describe "ユーザーデータの表示" do
      before do
        sign_in user
        visit root_path
        click_link "マイページ"
      end

      it "ユーザー名が表示される" do
        expect(page).to have_content(user.name)
      end

      context "ユーザー・ペット画像を登録しているとき" do
        let!(:updated_profile_user) { create(:user, :updated_profile_user) }
        let!(:human_avatar_filename) { user.human_avatar.filename.to_s }
        let!(:dog_avatar_filename) { user.dog_avatar.filename.to_s }

        before do
          sign_in updated_profile_user
          visit root_path
          click_link "マイページ"
        end

        it "ユーザー・ペット画像が表示される" do
          expect(find(".user-images-wrap").all("img")[0][:src]).to include(human_avatar_filename)
          expect(find(".user-images-wrap").all("img")[1][:src]).to include(dog_avatar_filename)
        end
      end

      context "ユーザー・ペット画像を登録していないとき" do
        it "未登録用の画像が表示される" do
          expect(find(".user-images-wrap").all("img")[0][:src]).to include("noavatar-human")
          expect(find(".user-images-wrap").all("img")[1][:src]).to include("noavatar-dog")
        end
      end
    end

    describe "登録件数の表示" do
      before do
        create_list(:spot, 1, spot_histories: [create(:spot_history, user: user)])
        create_list(:review, 3, user: user)
        create(:image, :attached, user: user)

        sign_in user
        visit root_path
        click_link "マイページ"
      end

      it "登録・更新したスポットの件数が表示される" do
        expect(find(".user-media-body").all(".count")[0]).to have_content(1)
      end

      it "投稿したレビューの件数が表示される" do
        expect(find(".user-media-body").all(".count")[1]).to have_content(3)
      end

      it "投稿した画像の件数が表示される" do
        expect(find(".user-media-body").all(".count")[2]).to have_content(2)
      end
    end

    describe "リンクの表示" do
      before do
        sign_in user
        visit root_path
        click_link "マイページ"
      end

      it "プロフィール編集ページヘのリンクがある" do
        expect(page).to have_link("プロフィール編集", href: users_mypage_profile_edit_path)
      end

      it "アカウント設定ページヘのリンクがある" do
        expect(page).to have_link("アカウント設定", href: edit_user_registration_path)
      end

      it "登録・更新したスポット一覧ページヘのリンクがある" do
        expect(page).to have_link("登録・更新したスポット", href: users_mypage_spot_index_path)
      end

      it "投稿レビュー一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿したレビュー", href: users_mypage_review_index_path)
      end

      it "投稿画像一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿した画像", href: users_mypage_image_index_path)
      end
    end
  end

  describe "タグづけしたスポット一覧ページ" do
    before do
      sign_in user
      visit users_mypage_spot_favorite_index_path
    end

    describe "タグづけしたスポットの表示" do
      describe "スポットのデータ" do
        let!(:spot) { create(:spot) }
        let(:helpful_review) { Review.last }
        let(:blobs) { ActiveStorage::Blob.all }
        let(:ranked_blobs_index) { [3, 1, 0, 2] }

        before do
          create(:spot_tag, spot: spot, user: user)
          create(:review, dog_score: 3, human_score: 4, spot: spot)
          create(:review, dog_score: 2, human_score: 3, spot: spot)
          create_list(:review_helpfulness, 1, review: helpful_review)
          create(:image, :attached, spot: spot, review: helpful_review)
          create(:image, :attached_1, spot: spot, review: Review.first)
          create(:image, :attached_2, spot: spot, review: Review.first)

          ranked_blobs_index.each_with_index do |index, i|
            create_list(:image_like, (5 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
          end

          click_link "タグをつけたスポット"
        end

        it "お気に入りしたスポット一覧ページヘのリンクがある" do
          expect(page).to have_link("お気に入りしたスポット", href: users_mypage_spot_favorite_index_path)
        end

        it_behaves_like "対象スポットのデータの表示"
        it_behaves_like "対象のスポットのレビューの表示"
        it_behaves_like "対象のスポットの画像の表示"
        it_behaves_like "マウスオーバーによる大きい画像の表示"
      end

      describe "スポットの表示順序" do
        let!(:spots) { create_list(:spot, 3) }
        let(:ordered_spots) { [spots[2], spots[0], spots[1]] }

        before do
          ordered_spots.each do |spot|
            create(:spot_tag, spot: spot, user: user)
          end

          click_link "タグをつけたスポット"
        end

        it "スポットがタグを作成した日の降順で表示される" do
          ordered_spots.reverse.each_with_index do |spot, i|
            expect(all(".list-content")[i]).to have_content(spot.name)
          end
        end
      end

      describe "タグの表示", js: true do
        let!(:spot) { create(:spot) }

        describe "表示の順序" do
          let!(:spot_tags) { create_list(:spot_tag, 10, spot: spot, user: user) }

          before do
            click_link "タグをつけたスポット"
            click_button "すべて"
          end

          it "ボタンをクリックすると、 作成したタグの一覧が作成日の降順で表示される" do
            spot_tags.reverse.each_with_index do |spot_tag, i|
              expect(all(".dropdown-item")[i + 1]).to have_content(spot_tag.name)
            end
          end
        end

        describe "表示の個数" do
          context "作成したタグが10個以下のとき" do
            let!(:spot_tags) { create_list(:spot_tag, 10, spot: spot, user: user) }

            before do
              click_link "タグをつけたスポット"
              click_button "すべて"
            end

            it "作成したタグがプルダウンにすべて表示される" do
              spot_tags.each_with_index do |spot_tag|
                expect(find(".dropdown-content")).to have_content(spot_tag.name)
              end
            end
          end

          context "作成したタグが10個超のとき" do
            let!(:first_created_tag) { create(:spot_tag, spot: spot, user: user, name: "最初のタグ", updated_at: Time.current.ago(2.days)) }
            let!(:spot_tags) do
              create_list(:spot_tag, 10, spot: spot, user: user)
              create_list(:spot_tag, 10, spot: spot, user: user)
              SpotTag.order(updated_at: :desc, created_at: :desc, id: :desc)
            end

            before do
              click_link "タグをつけたスポット"
              click_button "すべて"
            end

            it "作成日が新しい10個のタグのみプルダウンに表示される" do
              spot_tags.first(10).each do |spot_tag|
                expect(find(".dropdown-content")).to have_content(spot_tag.name)
              end

              spot_tags.first(-10).each do |spot_tag|
                expect(find(".dropdown-content")).not_to have_content(spot_tag.name)
              end
            end

            it "さらに表示をクリックすると、残りのタグが10個までプルダウンに表示される" do
              find(".js-show-more-trigger").click

              spot_tags.first(20).each do |spot_tag|
                expect(find(".dropdown-content")).to have_content(spot_tag.name)
              end

              expect(find(".dropdown-content")).not_to have_content(first_created_tag.name)
            end
          end
        end
      end

      describe "特定のタグがついたスポットの表示", js: true do
        let!(:spots) { create_list(:spot, 3) }
        let!(:spot_tag_0) { create(:spot_tag, spot: spots[0], user: user) }
        let!(:spot_tag_1) { create(:spot_tag, spot: spots[1], user: user) }
        let!(:spot_tag_2) { create(:spot_tag, spot: spots[2], user: user) }

        before { click_link "タグをつけたスポット" }

        context "タグを選択していないとき" do
          it "タグをつけた全てのスポットが表示される" do
            spots.each do |spot|
              expect(find(".user-marked-spot-list-wrap")).to have_content(spot.name)
            end
          end
        end

        context "すべてのタグを選択したとき" do
          before do
            click_button "すべて"
            within(".dropdown-content") do
              click_link "すべて"
            end
          end

          it "タグをつけた全てのスポットが表示される" do
            spots.each do |spot|
              expect(find(".user-marked-spot-list-wrap")).to have_content(spot.name)
            end
          end
        end

        context "特定のタグを選択したとき" do
          before do
            click_button "すべて"
            click_link spot_tag_1.name
          end

          it "選択したタグがついたスポットのみが表示される" do
            expect(find(".user-marked-spot-list-wrap")).to have_content(spots[1].name)
            expect(find(".user-marked-spot-list-wrap")).not_to have_content(spots[0].name)
            expect(find(".user-marked-spot-list-wrap")).not_to have_content(spots[2].name)
          end
        end
      end

      describe "ページネーション" do
        context "表示スポットが指定個数以上のとき" do
          let(:default_per_page) { Kaminari.config.default_per_page }

          before do
            create_list(:spot_tag, default_per_page + 1, user: user)
            sign_in user
            visit users_mypage_spot_tag_index_path
          end

          it "ページ割りされる" do
            expect(find(".spot-list-wrap").all(".list-content").length).to eq(default_per_page)
            expect(page).to have_selector(".pagination")
          end
        end
      end
    end

    describe "ユーザーデータの表示" do
      before do
        sign_in user
        visit users_mypage_spot_favorite_index_path
        click_link "タグをつけたスポット"
      end

      it "ユーザー名が表示される" do
        expect(page).to have_content(user.name)
      end

      context "ユーザー・ペット画像を登録しているとき" do
        let!(:updated_profile_user) { create(:user, :updated_profile_user) }
        let!(:human_avatar_filename) { user.human_avatar.filename.to_s }
        let!(:dog_avatar_filename) { user.dog_avatar.filename.to_s }

        before do
          sign_in updated_profile_user
          visit users_mypage_spot_favorite_index_path
          click_link "タグをつけたスポット"
        end

        it "ユーザー画像が表示される" do
          expect(find(".user-images-wrap").all("img")[0][:src]).to include(human_avatar_filename)
          expect(find(".user-images-wrap").all("img")[1][:src]).to include(dog_avatar_filename)
        end
      end

      context "ユーザー・ペット画像を登録していないとき" do
        it "未登録用の画像が表示される" do
          expect(find(".user-images-wrap").all("img")[0][:src]).to include("noavatar-human")
          expect(find(".user-images-wrap").all("img")[1][:src]).to include("noavatar-dog")
        end
      end
    end

    describe "登録件数の表示" do
      before do
        create_list(:spot, 1, spot_histories: [create(:spot_history, user: user)])
        create_list(:review, 3, user: user)
        create(:image, :attached, user: user)

        sign_in user
        visit users_mypage_spot_favorite_index_path
        click_link "タグをつけたスポット"
      end

      it "登録・更新したスポットの件数が表示される" do
        expect(find(".user-media-body").all(".count")[0]).to have_content(1)
      end

      it "投稿したレビューの件数が表示される" do
        expect(find(".user-media-body").all(".count")[1]).to have_content(3)
      end

      it "投稿した画像の件数が表示される" do
        expect(find(".user-media-body").all(".count")[2]).to have_content(2)
      end
    end

    describe "リンクの表示" do
      before do
        sign_in user
        visit users_mypage_spot_favorite_index_path
        click_link "タグをつけたスポット"
      end

      it "プロフィール編集ページヘのリンクがある" do
        expect(page).to have_link("プロフィール編集", href: users_mypage_profile_edit_path)
      end

      it "アカウント設定ページヘのリンクがある" do
        expect(page).to have_link("アカウント設定", href: edit_user_registration_path)
      end

      it "登録・更新したスポット一覧ページヘのリンクがある" do
        expect(page).to have_link("登録・更新したスポット", href: users_mypage_spot_index_path)
      end

      it "投稿レビュー一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿したレビュー", href: users_mypage_review_index_path)
      end

      it "投稿画像一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿した画像", href: users_mypage_image_index_path)
      end
    end
  end

  describe "登録・更新スポット一覧ページ" do
    before { sign_in user }

    describe "登録・更新したスポットの表示" do
      describe "スポットのデータ" do
        let!(:spot) { create(:spot, spot_histories: [create(:spot_history, user: user)]) }
        let(:helpful_review) { Review.last }
        let(:blobs) { ActiveStorage::Blob.all }
        let(:ranked_blobs_index) { [3, 1, 0, 2] }

        before do
          create(:spot_favorite, spot: spot, user: user)
          create(:review, dog_score: 3, human_score: 4, spot: spot)
          create(:review, dog_score: 2, human_score: 3, spot: spot)
          create_list(:review_helpfulness, 1, review: helpful_review)
          create(:image, :attached, spot: spot, review: helpful_review)
          create(:image, :attached_1, spot: spot, review: Review.first)
          create(:image, :attached_2, spot: spot, review: Review.first)

          ranked_blobs_index.each_with_index do |index, i|
            create_list(:image_like, (5 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
          end

          visit users_mypage_spot_index_path
        end

        it_behaves_like "対象スポットのデータの表示"
        it_behaves_like "対象のスポットのレビューの表示"
        it_behaves_like "対象のスポットの画像の表示"
        it_behaves_like "マウスオーバーによる大きい画像の表示"
      end

      describe "スポットの表示順序" do
        let!(:spot_history_0) { create(:spot_history, user: user, spot: create(:spot)) }
        let!(:spot_history_1) { create(:spot_history, user: user, spot: create(:spot)) }
        let!(:spot_history_2) { create(:spot_history, user: user, spot: create(:spot)) }

        before { visit users_mypage_spot_index_path }

        shared_examples "スポットの表示順序" do
          it "スポットが指定した順序で表示される" do
            ordered_spots.each_with_index do |spot, i|
              expect(all(".list-content")[i]).to have_content(spot.name)
            end
          end
        end

        context "表示の順番を指定していないとき" do
          let(:ordered_spots) { [spot_history_2.spot, spot_history_1.spot, spot_history_0.spot] }

          it_behaves_like "スポットの表示順序"
        end

        context "表示を新しい順にしたとき" do
          let(:ordered_spots) { [spot_history_2.spot, spot_history_1.spot, spot_history_0.spot] }

          before { click_link "新しい順" }

          it_behaves_like "スポットの表示順序"
        end

        context "表示を古い順にしたとき" do
          let(:ordered_spots) { [spot_history_0.spot, spot_history_1.spot, spot_history_2.spot] }

          before { click_link "古い順" }

          it_behaves_like "スポットの表示順序"
        end

        context "表示をお気に入りが多い順にしたとき" do
          let(:ordered_spots) { [spot_history_1.spot, spot_history_2.spot, spot_history_0.spot] }

          before do
            create_list(:spot_favorite, 2, spot: spot_history_1.spot)
            create_list(:spot_favorite, 1, spot: spot_history_2.spot)
            click_link "お気に入りが多い順"
          end

          it_behaves_like "スポットの表示順序"
        end
      end

      describe "ページネーション" do
        context "表示スポットが指定個数以上のとき" do
          let(:default_per_page) { Kaminari.config.default_per_page }

          before do
            create_list(:spot_history, default_per_page + 1, user: user)
            sign_in user
            visit users_mypage_spot_index_path
          end

          it "ページ割りされる" do
            expect(find(".spot-list-wrap").all(".list-content").length).to eq(default_per_page)
            expect(page).to have_selector(".pagination")
          end
        end
      end
    end

    describe "リンクの表示" do
      before { visit users_mypage_spot_index_path }

      it "マイページページヘのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: users_mypage_spot_favorite_index_path)
      end

      it "投稿レビュー一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿したレビュー", href: users_mypage_review_index_path)
      end

      it "投稿画像一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿した画像", href: users_mypage_image_index_path)
      end
    end
  end

  describe "投稿レビュー一覧ページ" do
    describe "投稿したレビューの表示" do
      let(:reviews) { Review.all.reverse }
      let!(:spots) { create_list(:spot, 3) }
      let!(:login_user) { create(:user, :updated_profile_user) }

      before do
        spots.each do |spot|
          create(:review, :with_image, user: login_user, spot: spot)
        end

        sign_in login_user
        visit users_mypage_review_index_path
      end

      describe "レビューの表示内容" do
        it "レビューのデータが表示される", js: true do
          reviews.each.with_index do |review, i|
            expect(page).to have_content(review.user.name)
            expect(all(".review-header")[i].find("img")[:src]).to include(review.user.human_avatar.blob.filename.to_s)
            expect(page).to have_content(I18n.l(review.visit_date, format: :short))
            expect(page).to have_content(review.title)
            expect(page).to have_content(review.comment)
            expect(page).to have_content(review.dog_score)
            expect(page).to have_content(review.human_score)
            expect(page).to have_content(I18n.l(review.created_at, format: :short))

            within(all(".dog-rating")[i]) do
              expect(all(".js-colored").length).to eq(review.dog_score)
            end

            within(all(".human-rating")[i]) do
              expect(all(".js-colored").length).to eq(review.human_score)
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

        it "レビューの画像を拡大表示できる", js: true do
          within(all(".review-images-wrap")[0]) do
            all("img")[0].click
            expect(page).to have_selector("#js-enlarged-image")
            expect(find("#js-enlarged-image")[:src]).to include(reviews[0].image.files_blobs[0].filename.to_s)
          end
        end
      end

      describe "レビューの表示順序" do
        shared_examples "レビューの表示順序" do
          it "レビューが指定した順序で表示される" do
            ordered_reviews.each_with_index do |review, i|
              expect(all(".review-content")[i]).to have_content(review.title)
            end
          end
        end

        context "表示の順番を指定していないとき" do
          let(:ordered_reviews) { Review.all.reverse }

          it_behaves_like "レビューの表示順序"
        end

        context "表示をスポットの名前順にしたとき" do
          let(:ordered_reviews) { Review.all }

          before { click_link "スポット名順" }

          it_behaves_like "レビューの表示順序"
        end

        context "表示を新しい順にしたとき" do
          let(:ordered_reviews) { Review.all.reverse }

          before { click_link "新しい順" }

          it_behaves_like "レビューの表示順序"
        end

        context "表示を古い順にしたとき" do
          let(:ordered_reviews) { Review.all }

          before { click_link "古い順" }

          it_behaves_like "レビューの表示順序"
        end

        context "表示を役に立ったが多い順にしたとき" do
          let(:ordered_reviews) { [reviews[1], reviews[0], reviews[2]] }

          before do
            create_list(:review_helpfulness, 3, review: reviews[1])
            create_list(:review_helpfulness, 2, review: reviews[0])
            click_link "役に立ったが多い順"
          end

          it_behaves_like "レビューの表示順序"
        end
      end

      describe "レビューの表示サイズ", js: true do
        context "レビューを表示する要素の高さが600px超のとき" do
          let(:height) { "400px" }
          let!(:review) { create(:review, user: login_user, comment: "長いコメント" * 10) }

          before { visit users_mypage_review_index_path }

          include_context "resize_browser_size", 100, 1000

          it "要素の高さが指定の高さになる" do
            expect(all(".js-card")[0].style("height")["height"]).to eq(height)
          end

          it "全表示のアイコンをクリックすると、元の高さで表示される" do
            find(".fa-angles-down").click
            expect(all(".js-card")[0].style("height")["height"]).not_to eq(height)
          end
        end
      end

      describe "ページネーション" do
        context "表示レビューが指定個数以上のとき" do
          let(:default_per_page) { Kaminari.config.default_per_page }

          before do
            create_list(:review, default_per_page + 1, user: user)
            sign_in user
            visit users_mypage_review_index_path
          end

          it "ページ割りされる" do
            expect(find(".review-list-wrap").all(".review-content").length).to eq(default_per_page)
            expect(page).to have_selector(".pagination")
          end
        end
      end
    end

    describe "リンクの表示" do
      before do
        sign_in user
        visit users_mypage_review_index_path
      end

      it "マイページページヘのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: users_mypage_spot_favorite_index_path)
      end

      it "登録・更新したスポット一覧ページヘのリンクがある" do
        expect(page).to have_link("登録・更新したスポット", href: users_mypage_spot_index_path)
      end

      it "投稿画像一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿した画像", href: users_mypage_image_index_path)
      end
    end
  end

  describe "投稿画像一覧ページ" do
    before { sign_in user }

    describe "投稿した画像の表示" do
      let!(:spot) { create(:spot) }
      let!(:image_0) { create(:image, :attached, spot: spot, user: user) }
      let!(:image_1) { create(:image, :attached_1, spot: spot, user: user) }
      let!(:filenames) { ActiveStorage::Blob.pluck(:filename) }

      before { visit users_mypage_image_index_path }

      it "画像を拡大表示できる", js: true do
        within(".image-list-wrap") do
          all("img")[0].click
          expect(page).to have_selector("#js-enlarged-image")
          expect(find("#js-enlarged-image")[:src]).to include(image_1.files_blobs[1].filename.to_s)
        end
      end

      shared_examples "画像の表示順序" do
        it "画像が指定した順序で表示される" do
          within(".image-list-wrap") do
            ordered_filenames.each_with_index do |filename, i|
              expect(page.all("img")[i][:src]).to include(filename)
            end
          end
        end
      end

      context "表示の順番を指定していないとき" do
        let(:ordered_filenames) { filenames.reverse }

        it_behaves_like "画像の表示順序"
      end

      context "表示を新しい順にしたとき" do
        let(:ordered_filenames) { filenames.reverse }

        before { click_link "新しい順" }

        it_behaves_like "画像の表示順序"
      end

      context "表示を古い順にしたとき" do
        let(:ordered_filenames) { filenames }

        before { click_link "古い順" }

        it_behaves_like "画像の表示順序"
      end

      context "表示をいいねが多い順にしたとき" do
        let(:most_liked_blob) { image_1.files_blobs[1] }
        let(:second_liked_blob) { image_0.files_blobs[1] }
        let(:ordered_filenames) { [most_liked_blob, second_liked_blob, image_1.files_blobs[0], image_0.files_blobs[0]].pluck(:filename) }

        before do
          create_list(:image_like, 3, image: image_1, blob_id: most_liked_blob.id)
          create_list(:image_like, 2, image: image_0, blob_id: second_liked_blob.id)
          click_link "いいねが多い順"
        end

        it_behaves_like "画像の表示順序"
      end
    end

    describe "ページネーション" do
      context "表示画像が指定個数以上のとき" do
        let!(:per_page) { stub_const("Image::PER_PAGE", 3) }

        before do
          create(:image, :attached, user: user)
          create(:image, :attached_1, user: user)
          visit users_mypage_image_index_path
        end

        it "ページ割りされる" do
          expect(find(".image-list-wrap").all("img").length).to eq(3)
          expect(page).to have_selector(".pagination")
        end
      end
    end

    describe "リンクの表示" do
      before { visit users_mypage_image_index_path }

      it "マイページページヘのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: users_mypage_spot_favorite_index_path)
      end

      it "登録・更新したスポット一覧ページヘのリンクがある" do
        expect(page).to have_link("登録・更新したスポット", href: users_mypage_spot_index_path)
      end

      it "投稿レビュー一覧ページヘのリンクがある" do
        expect(page).to have_link("投稿したレビュー", href: users_mypage_review_index_path)
      end
    end
  end

  describe "プロフィール編集ページ" do
    let!(:login_user) { create(:user, :updated_profile_user) }

    before do
      sign_in login_user
      visit users_mypage_profile_edit_path
    end

    describe "プロフィールの表示" do
      it "ユーザーのデータが表示される" do
        expect(page).to have_content(login_user.name)
        expect(page).to have_content(login_user.introduction)
      end

      context "ユーザー・ペット画像を登録しているとき" do
        let!(:human_avatar_filename) { login_user.human_avatar.filename.to_s }
        let!(:dog_avatar_filename) { login_user.dog_avatar.filename.to_s }

        it "ユーザー・ペット画像が表示される" do
          expect(all(".profile-image")[0].find("img")[:src]).to include(human_avatar_filename)
          expect(all(".profile-image")[1].find("img")[:src]).to include(dog_avatar_filename)
        end
      end

      context "ユーザー・ペット画像を登録していないとき" do
        let!(:human_avatar_filename) { user.human_avatar.filename.to_s }
        let!(:dog_avatar_filename) { user.dog_avatar.filename.to_s }

        before do
          sign_in user
          visit users_mypage_profile_edit_path
        end

        it "未登録用の画像が表示される" do
          expect(all(".profile-image")[0].find("img")[:src]).to include("noavatar-human")
          expect(all(".profile-image")[1].find("img")[:src]).to include("noavatar-dog")
        end
      end

      it "マイページへのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: users_mypage_spot_favorite_index_path)
      end
    end

    describe "プロフィールの編集", js: true do
      let!(:human_avatar_filename) { "test3.png" }
      let!(:dog_avatar_filename) { "test4.png" }

      before do
        attach_file "user[human_avatar]", "#{Rails.root}/spec/fixtures/images/#{human_avatar_filename}", make_visible: true
        attach_file "user[dog_avatar]", "#{Rails.root}/spec/fixtures/images/#{dog_avatar_filename}", make_visible: true
        fill_in "user[introduction]", with: "updated introduction"
        click_button "保存"
      end

      it "プロフィールを編集できる" do
        expect(page).to have_content("プロフィールを変更しました。")
        expect(login_user.reload.introduction).to eq("updated introduction")

        within(".user-media-head") do
          expect(all("img")[0][:src]).to include(human_avatar_filename)
          expect(all("img")[1][:src]).to include(dog_avatar_filename)
        end
      end
    end
  end

  describe "アカウント設定ページ" do
    before do
      sign_in user
      visit edit_user_registration_path
    end

    describe "アカウント設定ページの表示" do
      it "現在のメールアドレスがフォームに入力されている" do
        expect(find("#user_email").value).to eq(user.email)
      end

      it "マイページへのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: users_mypage_spot_favorite_index_path)
      end
    end

    describe "アカウント設定の変更", js: true do
      let(:updated_user) { build(:user) }

      before do
        fill_in "user[email]", with: updated_user.email
        fill_in "user[password]", with: updated_user.password
        fill_in "user[password_confirmation]", with: updated_user.password_confirmation
        fill_in "user[current_password]", with: user.password
        click_button "更新"
      end

      it "アカウント設定を変更でき、ホーム画面に遷移する" do
        expect(user.reload.email).to eq(updated_user.email)
        expect(user.valid_password?(updated_user.password)).to eq(true)
        expect(current_path).to eq(root_path)
        expect(page).to have_content("アカウント設定を変更しました。")
      end
    end

    describe "アカウントの削除", js: true do
      before { click_link "アカウントの削除" }

      context "confirmダイアログでOKをクリックすると" do
        it "アカウントを削除できて、ホーム画面に遷移する" do
          expect do
            expect(page.accept_confirm).to eq("本当に削除しますか？")
            expect(page).to have_content("アカウントを削除しました。またのご利用をお待ちしております。")
            expect(current_path).to eq(root_path)
          end.to change { User.count }.by(-1)
        end
      end

      context "confirmダイアログでキャンセルをクリックすると" do
        it "アカウントは削除されない" do
          expect do
            expect(page.dismiss_confirm).to eq("本当に削除しますか？")
          end.to change { User.count }.by(0)
        end
      end
    end
  end

  describe "ユーザーの新規登録ページ" do
    let(:new_user) { build(:user) }
    let(:sign_up_link) { all(".navbar-item", visible: false)[2] }

    describe "新規登録ページの表示" do
      before do
        visit root_path
        click_link "新規登録"
      end

      it "トップページヘのリンクがある" do
        expect(find(".page-link-wrap")).to have_link("TOP", href: root_path)
      end

      it "ログインページヘのリンクがある" do
        expect(find(".account-help-links-wrap")).to have_link("すでにアカウントをお持ちの方はこちら", href: new_user_session_path)
      end
    end

    describe "新規登録", js: true do
      before do
        visit root_path
        resize_browser_size(width: 1500)
        click_link "新規登録"
        fill_in "user[name]", with: new_user.name
        fill_in "user[email]", with: new_user.email
        fill_in "user[password]", with: new_user.password
        fill_in "user[password_confirmation]", with: new_user.password_confirmation
      end

      it "新規ユーザーが登録できる" do
        expect do
          click_button "新しいアカウントを登録する"
        end.to change { User.count }.by(1)

        expect(page).to have_content("アカウント登録が完了しました。")
      end
    end
  end

  describe "ログインページ" do
    before do
      visit root_path
      click_link "ログイン"
    end

    describe "ログインページの表示" do
      it "トップページヘのリンクがある" do
        expect(find(".page-link-wrap")).to have_link("TOP", href: root_path)
      end

      it "新規登録ページヘのリンクがある" do
        expect(find(".account-help-links-wrap")).to have_link("アカウントをお持ちでない方はこちら", href: new_user_registration_path)
      end

      it "パスワード再設定ページヘのリンクがある" do
        expect(find(".account-help-links-wrap")).to have_link("パスワードをお忘れですか？", href: new_user_password_path)
      end
    end

    describe "ログイン" do
      before do
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "ログイン"
      end

      it "ログインできる" do
        expect(page).to have_content("ログインしました。")
      end
    end
  end

  describe "パスワードの再設定ページ" do
    let(:delivered_mail) { ActionMailer::Base.deliveries.last }
    let(:password_reset_url) { URI.extract(delivered_mail.body.encoded).first }

    before do
      visit new_user_session_path
      click_link "パスワードをお忘れですか？"
    end

    describe "パスワード再設定ページの表示" do
      it "トップページヘのリンクがある" do
        expect(find(".page-link-wrap")).to have_link("TOP", href: root_path)
      end

      it "新規登録ページヘのリンクがある" do
        expect(find(".account-help-links-wrap")).to have_link("アカウントをお持ちでない方はこちら", href: new_user_registration_path)
      end
    end

    describe "パスワードの再設定" do
      before { fill_in "user[email]", with: user.email }

      it "入力したアドレスに、再設定用のメールが送信される" do
        expect do
          click_button "パスワード再設定のメールを送信"
        end.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(page).to have_content("パスワードの再設定について数分以内にメールでご連絡いたします。")

        expect(delivered_mail.from).to eq("Wan Family")
        expect(delivered_mail.to.first).to eq(user.email)
        expect(delivered_mail.subject).to eq("パスワードの再設定について")
        expect(delivered_mail.body).to have_link("パスワードの変更", href: password_reset_url)
      end

      it "送信されたメールのリンクから、パスワードを変更できる" do
        click_button "パスワード再設定のメールを送信"
        visit password_reset_url
        fill_in "user[password]", with: "resetpass00"
        fill_in "user[password_confirmation]", with: "resetpass00"
        click_button "新しいパスワードを設定する"

        expect(page).to have_content("パスワードが正しく変更されました。")
        expect(current_path).to eq(root_path)
        expect(user.reload.valid_password?("resetpass00")).to eq(true)
      end
    end
  end

  describe "ログアウト" do
    before do
      sign_in user
      visit root_path
      click_link "ログアウト"
    end

    it "ログアウトできる" do
      expect(page).to have_content("ログアウトしました。")
    end
  end
end
