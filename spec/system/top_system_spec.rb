require 'rails_helper'

RSpec.describe "TopSystemSpecs", type: :system do
  describe "トップページ" do
    describe "トップページの表示" do
      describe "注目のスポット" do
        let!(:region) { create(:region) }
        let!(:prefecture) { create(:prefecture, region: region) }
        let!(:spots) { create_list(:spot, 11, prefecture: prefecture) }
        let!(:images) do
          Spot.all.map do |spot|
            create(:image, :attached, spot: spot, review: create(:review, spot: spot))
          end
        end

        context "一週間のうちにお気に入り登録されたスポットが10個以上あるとき" do
          let(:ordered_index) { [3, 5, 2, 0, 6, 4, 8, 9, 1, 7] }
          let(:ranked_index) { ordered_index }

          before do
            create_list(:spot_favorite, 11, created_at: Time.current.last_year, spot: spots.last)

            ordered_index.each_with_index do |index, i|
              create_list(:spot_favorite, (10 - i), spot: spots[index])
            end

            ranked_index.each do |index|
              create(:image_like, image: images[index], blob_id: images[index].files_blobs[0].id)
            end

            visit root_path
          end

          it "一週間の登録数、上位10個のスポットのデータが、登録数が多い順に表示される" do
            ranked_index.each_with_index do |index, i|
              expect(all(".top-content")[i]).to have_content(spots[index].name)
              expect(all(".top-content")[i]).to have_link(href: spot_path(spots[index]))
            end
          end

          it "スポットに投稿された画像の中で、それぞれの最もいいねが登録されている画像を表示する" do
            ranked_index.each_with_index do |index, i|
              expect(all(".top-content")[i].find("img")[:src]).to include(images[index].files_blobs[0].filename.to_s)
            end
          end
        end

        context "一週間のうちにお気に入り登録されたスポットが10個未満のとき" do
          let(:ordered_index) { [3, 5, 2, 0, 6, 4, 8, 9, 1] }
          let(:ranked_index) { ordered_index.push(10) }

          before do
            create_list(:spot_favorite, 10, created_at: Date.today.last_year, spot: spots.last)

            ordered_index.each_with_index do |index, i|
              create_list(:spot_favorite, (9 - i), spot: spots[index])
            end

            ranked_index.each do |index|
              create(:image_like, image: images[index], blob_id: images[index].files_blobs[0].id)
            end

            visit root_path
          end

          it "一週間より前の登録も含めて、上位10個のスポットのデータが、登録数が多い順に表示される" do
            ranked_index.each_with_index do |index, i|
              expect(all(".top-content")[i]).to have_content(spots[index].name)
              expect(all(".top-content")[i]).to have_link(href: spot_path(spots[index]))
            end
          end

          it "スポットに投稿された画像の中で、それぞれの最もいいねが登録されている画像を表示する" do
            ranked_index.each_with_index do |index, i|
              expect(all(".top-content")[i].find("img")[:src]).to include(images[index].files_blobs[0].filename.to_s)
            end
          end
        end
      end

      describe "スポットの検索フォーム" do
        let!(:categories) { create_list(:category, 3) }
        let!(:allowed_areas) { create_list(:allowed_area, 3) }
        let!(:regions) { create_list(:region, 3) }
        let!(:prefectures) { create_list(:prefecture, 3) }
        let(:locator) { find(".top-search-form-wrap") }

        before { visit root_path }

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_regions"
        it_behaves_like "displays_all_prefectures"
      end

      describe "みんなのお気に入り" do
        let!(:region) { create(:region) }
        let!(:prefecture) { create(:prefecture, region: region) }
        let!(:spots) { create_list(:spot, 10, prefecture: prefecture) }
        let!(:images) do
          Spot.all.map do |spot|
            create(:image, :attached, spot: spot, review: create(:review, spot: spot))
          end
        end
        let(:ranked_index) { [3, 5, 2, 0, 6, 4, 8, 9, 1, 7] }

        before do
          ranked_index.each_with_index do |index, i|
            create_list(:spot_favorite, (10 - i), spot: spots[index])
          end

          ranked_index.each do |index|
            create(:image_like, image: images[index], blob_id: images[index].files_blobs[0].id)
          end

          visit root_path
        end

        it "登録数上位10個までのスポットのデータが、登録数が多い順に表示される" do
          ranked_index.each_with_index do |index, i|
            expect(all(".popular-spot-list-item")[i]).to have_content(spots[index].name)
            expect(all(".popular-spot-list-item")[i]).to have_content(spots[index].prefecture.name)
            expect(all(".popular-spot-list-item")[i]).to have_content(spots[index].category.name)
            expect(all(".popular-spot-list-item")[i]).to have_link(href: spot_path(spots[index]))
          end
        end

        it "スポットに投稿された画像の中で、それぞれの最もいいねが登録されている画像を表示する" do
          ranked_index.each_with_index do |index, i|
            expect(all(".popular-spot-list-item")[i].find("img")[:src]).to include(images[index].files_blobs[0].filename.to_s)
          end
        end
      end

      describe "エリアから探す" do
        let!(:regions) { create_list(:region, 2) }

        before do
          create_list(:spot, 2, prefecture: create(:prefecture, region: regions[0]))
          create(:spot, prefecture: create(:prefecture, region: regions[1]))
          visit root_path
        end

        it "全ての地方名と、そこに所在地があるスポットの件数が表示される" do
          expect(all(".region-card")[0]).to have_link(regions[0].name, href: word_search_path(q: { and: { prefecture_id_matches_any: regions[0].prefectures.ids } }))
          expect(all(".region-name")[0]).to have_content(2)
          expect(all(".region-card")[1]).to have_link(regions[1].name, href: word_search_path(q: { and: { prefecture_id_matches_any: regions[1].prefectures.ids } }))
          expect(all(".region-name")[1]).to have_content(1)
        end
      end

      describe "マップで探す" do
        let!(:regions) { create_list(:region, 2) }

        before { visit root_path }

        it "全ての地方名が表示される" do
          expect(all(".map-link-btn")[0]).to have_link(regions[0].name, href: map_search_path(region: regions[0].name_roma))
          expect(all(".map-link-btn")[1]).to have_link(regions[1].name, href: map_search_path(region: regions[1].name_roma))
        end
      end

      describe "いいねをたくさんもらった子たちをご紹介" do
        let!(:images) { create_list(:image, 6, :attached, review: create(:review)) }
        let(:blobs) { ActiveStorage::Blob.all }

        describe "画像の表示順序" do
          context "一週間のうちにいいね登録された画像が10個以上あるとき" do
            let(:ordered_index) { [3, 5, 2, 0, 6, 4, 8, 9, 1, 7] }
            let(:ranked_index) { ordered_index }

            before do
              create_list(:image_like, 11, created_at: Date.today.last_year, image: blobs.last.attachments[0].record, blob_id: blobs.last.id)

              ordered_index.each_with_index do |index, i|
                create_list(:image_like, (10 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
              end

              visit root_path
            end

            it "一週間の登録数、上位10個の画像が、登録数が多い順に表示される" do
              ranked_index.each_with_index do |index, i|
                expect(all(".image-link-list-item")[i]).to have_selector("#image_blob_#{blobs[index].id}")
              end
            end
          end

          context "一週間のうちにお気に入り登録された画像が10個未満のとき" do
            let(:ordered_index) { [3, 5, 2, 0, 6, 4, 8, 9, 1] }
            let(:ranked_index) { ordered_index.push(11) }

            before do
              create_list(:image_like, 10, created_at: Date.today.last_year, image: blobs.last.attachments[0].record, blob_id: blobs.last.id)

              ordered_index.each_with_index do |index, i|
                create_list(:image_like, (9 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
              end

              visit root_path
            end

            it "一週間より前の登録も含めて、上位10個の画像が、登録数が多い順に表示される" do
              ranked_index.each_with_index do |index, i|
                expect(all(".image-link-list-item")[i]).to have_selector("#image_blob_#{blobs[index].id}")
              end
            end
          end
        end

        describe "画像の拡大表示" do
          let(:target_image_blob) { images.last.files_blobs.last }

          before { visit root_path }

          it "画像を拡大表示できる", js: true do
            within(".image-like-list-wrap") do
              find("#image_blob_#{target_image_blob.id}").click
              expect(page).to have_selector("#js-enlarged-image")
              expect(find("#js-enlarged-image")[:src]).to include(target_image_blob.filename.to_s)
            end
          end
        end
      end
    end

    describe "スポットの検索" do
      describe "キーワード検索", js: true do
        let!(:spot) { create(:spot) }

        before do
          visit root_path
          within(".top-search-form-wrap") do
            fill_in "q_and_name_or_address_cont", with: spot.name
          end
        end

        it "スポットのキーワード検索ができる" do
          find(".search_btn").click
          expect(current_path).to eq(word_search_path)
          expect(find(".search-result-wrap")).to have_content(spot.name)
        end

        it "検索条件のクリアボタンをクリックすると、入力したワードが消える" do
          within(".top-search-form-wrap") do
            find(".js-search-condition-clear-btn").click
            expect(find(".js-name-or-address-input").value).to eq("")
          end
        end
      end

      describe "詳細検索", js: true do
        let!(:spot) { create(:spot) }
        let!(:categories) { create_list(:category, 2) }
        let!(:allowed_areas) { create_list(:allowed_area, 2) }
        let!(:prefectures) { create_list(:prefecture, 2) }

        before do
          visit root_path
          within(".top-search-form-wrap") do
            find("label[for='top_q_category_#{spot.category.id}']").click
            find("label[for='top_q_allowed_area_#{spot.allowed_area.id}']").click
            select spot.prefecture.name
          end
        end

        it "スポットの詳細検索ができる" do
          find(".search_btn").click
          expect(current_path).to eq(word_search_path)
          expect(find(".search-result-wrap")).to have_content(spot.name)
        end

        it "選択した条件のチェックボックスに色が付く" do
          expect(all(".js-colored-option-btn")[0]).to have_content(spot.category.name)
          expect(all(".js-colored-option-btn")[1]).to have_content(spot.allowed_area.area)
        end

        it "検索条件のクリアボタンをクリックすると、選択した条件が未選択になる" do
          within(".top-search-form-wrap") do
            find(".js-search-condition-clear-btn").click
            expect(find("#top_q_category_#{spot.category.id}", visible: false).checked?).to eq(false)
            expect(find("#top_q_allowed_area_#{spot.allowed_area.id}", visible: false).checked?).to eq(false)
            expect(find("option[value='#{spot.prefecture.id}']", visible: false).selected?).to eq(false)
            expect(page).not_to have_selector(".js-colored-option-btn")
          end
        end
      end

      describe "エリア検索" do
        let!(:regions) { create_list(:region, 2) }
        let!(:prefecture_0) { create(:prefecture, region: regions[0]) }
        let!(:prefecture_1) { create(:prefecture, region: regions[0]) }
        let!(:prefecture_2) { create(:prefecture, region: regions[1]) }
        let!(:spot_0) { create(:spot, prefecture: prefecture_0) }
        let!(:spot_1) { create(:spot, prefecture: prefecture_1) }
        let!(:spot_2) { create(:spot, prefecture: prefecture_2) }

        before do
          visit root_path
          find(".area-search-wrap").all("a")[0].click
        end

        it "選択した地方に属する県に所在するスポットを検索できる" do
          expect(current_path).to eq(word_search_path)
          expect(page).to have_content(spot_0.name)
          expect(page).to have_content(spot_1.name)
          expect(page).not_to have_content(spot_2.name)
        end
      end
    end
  end

  describe "スポットのキーワード・詳細検索結果ページ", js: true do
    describe "検索結果ページの表示" do
      let!(:spot) { create(:spot) }
      let!(:helpful_review) { create(:review, dog_score: 3, human_score: 4, spot: spot) }
      let(:blobs) { ActiveStorage::Blob.all }
      let(:ranked_blobs_index) { [3, 1, 0, 2] }

      before do
        create_list(:spot_favorite, 2, spot: spot)
        create(:review_helpfulness, review: helpful_review)
        create(:image, :attached_1, spot: spot, review: create(:review, dog_score: 2, human_score: 3, spot: spot))
        create(:image, :attached, spot: spot, review: helpful_review)

        ranked_blobs_index.each_with_index do |index, i|
          create_list(:image_like, (5 - i), image: blobs[index].attachments[0].record, blob_id: blobs[index].id)
        end

        visit root_path

        within(".top-search-form-wrap") do
          fill_in "q_and_name_or_address_cont", with: spot.name
          find("label[for='top_q_category_#{spot.category.id}']").click
          find("label[for='top_q_allowed_area_#{spot.allowed_area.id}']").click
          select spot.prefecture.name
          find(".search_btn").click
        end
      end

      it "検索したキーワードが検索バーに表示される" do
        expect(find("#q_and_name_or_address_cont").value).to eq(spot.name)
      end

      it "検索した条件が詳細条件に表示される" do
        find(".search-filter-open-btn").click
        expect(find("#header_q_category_#{spot.category.id}", visible: false).checked?).to eq(true)
        expect(all(".js-colored-option-btn")[0]).to have_content(spot.category.name)
        expect(find("#header_q_allowed_area_#{spot.allowed_area.id}", visible: false).checked?).to eq(true)
        expect(all(".js-colored-option-btn")[1]).to have_content(spot.allowed_area.area)
        expect(find("option[value='#{spot.prefecture.id}']", visible: false).selected?).to eq(true)
      end

      it "検索結果として出たスポットの件数が表示される" do
        expect(find(".search-result-title").find("span")).to have_content("（1件）")
      end

      it_behaves_like "displays_the_data_of_the_target_spot"
      it_behaves_like "displays_the_most_helpful_reviews_posted_on_the_target_spot"
      it_behaves_like "displays_the_top_5_liked_images_posted_on_the_target_spot"
      it_behaves_like "displays_small_image_on_the_display_of_large_image_when_mouse_hovers_over_it"
    end

    describe "スポットの表示順序" do
      let(:spots) { Spot.all }
      let!(:category) { create(:category) }

      before do
        create_list(:spot, 3, category: category)

        visit root_path

        within(".top-search-form-wrap") do
          find("label[for='top_q_category_#{category.id}']").click
          find(".search_btn").click
        end
      end

      shared_examples "displays_spots_in_the_specified_order" do
        it "スポットが指定した順序で表示される" do
          sleep 0.5
          ordered_spots.each_with_index do |spot, i|
            expect(all(".list-content")[i]).to have_content(spot.name)
          end
        end
      end

      context "表示の順番を指定していないとき" do
        let(:ordered_spots) { spots.reverse }

        it_behaves_like "displays_spots_in_the_specified_order"
      end

      context "表示を新しい順にしたとき" do
        let(:ordered_spots) { spots.reverse }

        before { click_link "新しい順" }

        it_behaves_like "displays_spots_in_the_specified_order"
      end

      context "表示を古い順にしたとき" do
        let(:ordered_spots) { spots }

        before { click_link "古い順" }

        it_behaves_like "displays_spots_in_the_specified_order"
      end

      context "表示をお気に入りが多い順にしたとき" do
        let(:ordered_spots) { [spots[1], spots[2], spots[0]] }

        before do
          create_list(:spot_favorite, 2, spot: spots[1])
          create_list(:spot_favorite, 1, spot: spots[2])
          click_link "お気に入りが多い順"
        end

        it_behaves_like "displays_spots_in_the_specified_order"
      end
    end

    describe "ページネーション" do
      context "表示スポットが指定個数以上のとき" do
        let!(:category) { create(:category) }
        let(:default_per_page) { Kaminari.config.default_per_page }

        before do
          create_list(:spot, default_per_page + 1, category: category, prefecture: create(:prefecture, region: create(:region)))

          visit root_path

          within(".top-search-form-wrap") do
            find("label[for='top_q_category_#{category.id}']").click
            find(".search_btn").click
          end
        end

        it "ページ割りされる" do
          expect(find(".search-result-wrap").all(".list-content").length).to eq(default_per_page)
          expect(page).to have_selector(".pagination")
        end
      end
    end
  end

  describe "スポットのマップ検索ページ", js: true do
    let!(:spot) { create(:spot, :real_spot) }

    before do
      create(:spot, latitude: 34.6827, longitude: 135.5262)

      visit map_search_path
      sleep 1
      page.execute_script("document.getElementsByTagName('area')[0].click();")
    end

    context "マーカーをクリックしたとき" do
      let(:info_window) { find(".map-info", visible: false) }

      it "クリックした場所のスポットのデータが表示される" do
        expect(info_window).to have_selector("a", visible: false, text: spot.name)
        expect(info_window).to have_selector("span", visible: false, text: spot.address)
        expect(info_window).to have_selector("span", visible: false, text: spot.category.name)
      end
    end

    context "別のスポットの情報ウィンドウが表示されている状態で、マーカーをクリックしたとき" do
      let(:info_window) { all(".map-info", visible: false) }

      before { page.execute_script("document.getElementsByTagName('area')[1].click();") }

      it "先に開かれていた方の情報ウィンドウが閉じる" do
        expect(info_window.length).to eq(1)
      end
    end
  end
end
