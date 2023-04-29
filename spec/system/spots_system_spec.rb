require 'rails_helper'
require 'support/shared_examples/system_spec'

RSpec.describe "SpotsSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:categories) { create_list(:category, 2) }
  let!(:allowed_areas) { create_list(:allowed_area, 2) }
  let!(:rule_options) { create_list(:rule_option, 2) }
  let!(:option_titles) { OptionTitle.all }
  let!(:prefecture) { create(:prefecture, :real_prefecture) }
  let(:locator) { find(".spot-register-form-wrap") }

  describe "新しいスポットの登録" do
    let!(:spot) { build(:spot, :real_spot) }

    before do
      sign_in user
      visit new_spot_path
    end

    shared_context "有効な登録内容の入力" do
      before do
        fill_in "spot_name_input", with: spot.name
        fill_in "spot_address_input", with: spot.address
        page.execute_script("document.getElementById('spot_lat_input').value = #{spot.latitude}")
        page.execute_script("document.getElementById('spot_lng_input').value = #{spot.longitude}")
        select categories[0].name, from: "スポットカテゴリー"
        select allowed_areas[0].area, from: "同伴可能エリア"
        fill_in "spot_official_site_input", with: spot.official_site
        check rule_options[0].name
        click_button "入力内容の確認へ"
      end
    end

    describe "登録内容入力ページ" do
      describe "入力ページの表示" do
        before { visit new_spot_path }

        it "トップページへのリンクがある" do
          expect(find(".page-link-wrap")).to have_link("TOP", href: root_path)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end

      describe "登録内容の入力" do
        context "入力内容が妥当なとき", js: true do
          include_context "有効な登録内容の入力"

          it "確認ページへ遷移する" do
            expect(current_path).to eq(new_confirm_spots_path)
          end
        end

        context "入力内容が不正なとき", js: true do
          before do
            check rule_options[0].name
            click_button "入力内容の確認へ"
          end

          it "バリデーションエラーが表示される" do
            expect(page).to have_content("#{Spot.human_attribute_name(:name)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:address)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:category)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
          end

          it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
            expect(page).not_to have_content("#{Spot.human_attribute_name(:latitude)}を入力してください")
            expect(page).not_to have_content("#{Spot.human_attribute_name(:longitude)}を入力してください")
            expect(page).not_to have_content("#{Spot.human_attribute_name(:prefecture)}を入力してください")
          end

          it "チェックを付けていた同伴ルールには、そのままチェックが付く" do
            expect(page).to have_checked_field(rule_options[0].name)
            expect(page).to have_unchecked_field(rule_options[1].name)
          end
        end
      end
    end

    describe "入力内容確認ページ", js: true do
      include_context "有効な登録内容の入力"

      describe "確認ページの表示" do
        it "入力した内容が表示される" do
          expect(page).to have_content(spot.name)
          expect(page).to have_content(spot.address)
          expect(page).to have_content(categories[0].name)
          expect(page).to have_content(allowed_areas[0].area)
          expect(page).to have_content(spot.official_site)
          expect(page).to have_content(rule_options[0].name)
          expect(page).not_to have_content(rule_options[1].name)
        end

        it "入力画面に戻るボタンがある" do
          expect(page).to have_button("入力画面に戻る")
        end
      end

      describe "登録の完了" do
        let(:new_spot) { Spot.last }
        let(:new_rules) { new_spot.rules }

        it "スポットを登録できる" do
          expect { click_button "入力した内容で登録する"}.to change { Spot.count }.by(1)
          expect(new_spot.name).to eq(spot.name)
          expect(new_spot.latitude).to eq(spot.latitude)
          expect(new_spot.longitude).to eq(spot.longitude)
          expect(new_spot.address).to eq(spot.address)
          expect(new_spot.official_site).to eq(spot.official_site)
          expect(new_spot.allowed_area_id).to eq(allowed_areas[0].id)
          expect(new_spot.category_id).to eq(categories[0].id)
          expect(new_spot.prefecture_id).to eq(prefecture.id)
        end

        it "スポットに紐づく同伴ルールを登録できる" do
          expect { click_button "入力した内容で登録する"}.to change { Rule.count }.by(RuleOption.count)
          expect(new_rules.find_by(rule_option_id: rule_options[0].id).answer).to eq("1")
          expect(new_rules.find_by(rule_option_id: rule_options[1].id).answer).to eq("0")
        end
      end
    end

    describe "入力内容の訂正ページ", js: true do
      let(:corrected_spot) { build(:spot) }

      include_context "有効な登録内容の入力"

      before { click_button "入力画面に戻る" }

      describe "戻った入力画面の表示" do
        it "入力欄に、最初に入力した内容が入っている" do
          expect(find("#spot_name_input").value).to eq(spot.name)
          expect(find("#spot_lat_input", visible: false).value.to_f).to eq(spot.latitude)
          expect(find("#spot_lng_input", visible: false).value.to_f).to eq(spot.longitude)
          expect(find("#spot_address_input").value).to eq(spot.address)
          expect(find("#spot_official_site_input").value).to eq(spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: categories[0].name)
          expect(page).to have_select("同伴可能エリア", selected: allowed_areas[0].area)
          expect(page).to have_checked_field(rule_options[0].name)
          expect(page).to have_unchecked_field(rule_options[1].name)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end
    end
  end

  describe "スポット詳細ページ" do
    let!(:spot) { create(:spot) }

    describe "ページヘッダーの表示", js: true do
      before do
        create(:review, dog_score: 3, human_score: 4, spot: spot)
        create(:review, dog_score: 2, human_score: 4, spot: spot)
        create(:review, dog_score: 3, human_score: 3, spot: spot)
        create_list(:favorite_spot, 2, spot: spot)
        visit spot_path(spot)
      end

      it "ヘッダーに、スポットのデータが表示される" do
        expect(page).to have_content(spot.name)
        expect(page).to have_content(spot.address)
        expect(page).to have_content(spot.category.name)
        expect(page).to have_content(spot.allowed_area.area)
        expect(page).to have_content(I18n.l spot.updated_at, format: :short)
        expect(find(".favorite-count")).to have_content(spot.favorite_spots.size)
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

      it "スポットに投稿された画像一覧ページへのリンクがある" do
        expect(find(".header-tabs")).to have_link("画像", href: spot_images_path(spot))
      end

      it "スポットに投稿されたレビュー一覧ページへのリンクがある" do
        expect(find(".header-tabs")).to have_link("レビュー", href: spot_reviews_path(spot))
        expect(find(".article-link")).to have_link("レビューをもっと見る", href: spot_reviews_path(spot))
      end
    end

    describe "スポットの投稿画像", js: true do
      let!(:image_0) { create(:image, :attached, spot: spot) }
      let!(:image_1) { create(:image, :attached_1, spot: spot) }
      let(:ordered_filenames) { [image_1.files_blobs[0].filename, image_0.files_blobs[0].filename] }

      before do
        create_list(:image, 11, :attached, spot: spot)
        create_list(:image_like, 2, image: image_1, blob_id: image_1.files_blobs[0].id)
        create_list(:image_like, 1, image: image_0, blob_id: image_0.files_blobs[0].id)
        visit spot_path(spot)
      end

      it "スポットに投稿された画像がいいねが多い順に上限数だけ表示される" do
        ordered_filenames.each_with_index do |filename, i|
          expect(find(".small-image").all("img")[i][:src]).to include(filename.to_s)
        end

        expect(find(".small-image").all("img").length).to eq(10)
      end

      it "小画像をマウスオーバーすると、大画像のディスプレイに表示される" do
        find(".small-image").all("img")[0].hover
        expect(find(".large-image").find("img")[:src]).to eq(find(".small-image").all("img")[0][:src])
      end
    end

    describe "スポットの投稿レビュー", js: true do
      let!(:reviews) { create_list(:review, 3, :with_image, spot: spot) }
      let(:ordered_reviews) { [reviews[2], reviews[1], reviews[0]] }

      before do
        create_list(:review_helpfulness, 2, review: reviews[2])
        create_list(:review_helpfulness, 1, review: reviews[1])
        sign_in user
        visit spot_path(spot)
      end

      it "スポットに投稿されたレビューが役立ったが多い順に上限数だけ表示される" do
        ordered_reviews.each.with_index do |review, i|
          within(all(".review-content")[i]) do
            expect(page).to have_content(review.user.name)
            expect(find(".review-header").find("img")[:src]).to include("noavatar-human")
            expect(page).to have_content(I18n.l review.visit_date, format: :short)
            expect(page).to have_content(review.title)
            expect(page).to have_content(review.comment)
            expect(page).to have_content(review.dog_score)
            expect(page).to have_content(review.human_score)
            expect(page).to have_content(I18n.l review.created_at, format: :short)

            within(".dog-rating") do
              expect(all(".js-colored").length).to eq(review.dog_score)
            end

            within(".human-rating") do
              expect(all(".js-colored").length).to eq(review.human_score)
            end

            within(".review-images-wrap") do
              review.image.files_blobs.each_with_index do |blob, j|
                expect(all("img")[j][:src]).to include(blob.filename.to_s)
              end
            end
          end
        end
      end

      it "レビューに役立ったを登録できる" do
        within(all(".review-content")[0]) do
          expect do
            find(".review-helpfulness-add-btn").click
            expect(find(".review-helpfulness-btn-wrap")).to have_content(ordered_reviews[0].review_helpfulnesses.size)
          end.to change { ReviewHelpfulness.count }.by(1)

          expect(ReviewHelpfulness.last.user_id).to eq(user.id)
          expect(ReviewHelpfulness.last.review_id).to eq(ordered_reviews[0].id)
        end
      end

      it "レビューの画像を拡大表示できる" do
        within(all(".review-images-wrap")[0]) do
          all("img")[0].click
          expect(page).to have_selector("#js-enlarged-image")
          expect(find("#js-enlarged-image")[:src]).to include(ordered_reviews[0].image.files_blobs[0].filename.to_s)
        end
      end
    end

    describe "スポットの基本情報" do
      let!(:spot_with_rules) { create(:spot, :with_rules) }
      let(:attached_rules) { spot_with_rules.rules.where(answer: "1") }
      let(:unattached_rules) { spot_with_rules.rules.where(answer: "0") }

      before { visit spot_path(spot_with_rules) }

      it "スポットの基本情報の欄に、スポットのデータが表示される" do
        expect(page).to have_content(spot_with_rules.name)
        expect(page).to have_content(spot_with_rules.address)
        expect(page).to have_content(spot_with_rules.category.name)
        expect(page).to have_content(spot_with_rules.allowed_area.area)
        expect(page).to have_content(spot_with_rules.official_site)

        attached_rules.each do |attached_rule|
          expect(page).to have_content(attached_rule.rule_option.name)
        end

        unattached_rules.each do |unattached_rule|
          expect(page).not_to have_content(unattached_rule.rule_option.name)
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

  describe "スポットの更新" do
    let!(:spot) { create(:spot) }
    let!(:updated_spot) { build(:spot, :real_spot) }

    before do
      create(:rule, spot: spot, rule_option: rule_options[0], answer: "1")
      create(:rule, spot: spot, rule_option: rule_options[1], answer: "0")
    end

    shared_context "有効な更新内容の入力" do
      before do
        sign_in user
        visit spot_path(spot)
        click_link "スポットの情報を更新"
        fill_in "spot_name_input", with: updated_spot.name
        fill_in "spot_address_input", with: updated_spot.address
        page.execute_script("document.getElementById('spot_lat_input').value = #{updated_spot.latitude}")
        page.execute_script("document.getElementById('spot_lng_input').value = #{updated_spot.longitude}")
        select categories[1].name, from: "スポットカテゴリー"
        select allowed_areas[1].area, from: "同伴可能エリア"
        fill_in "spot_official_site_input", with: updated_spot.official_site
        check rule_options[1].name
        uncheck rule_options[0].name
        click_button "入力内容の確認へ"
      end
    end

    describe "更新内容の入力ページ" do
      describe "入力項目の表示" do
        before do
          sign_in user
          visit spot_path(spot)
          click_link "スポットの情報を更新"
        end

        it "更新対象のスポットのデータが入力欄に入っている" do
          expect(find("#spot_name_input").value).to eq(spot.name)
          expect(find("#spot_lat_input", visible: false).value.to_f).to eq(spot.latitude)
          expect(find("#spot_lng_input", visible: false).value.to_f).to eq(spot.longitude)
          expect(find("#spot_address_input").value).to eq(spot.address)
          expect(find("#spot_official_site_input").value).to eq(spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: spot.category.name)
          expect(page).to have_select("同伴可能エリア", selected: spot.allowed_area.area)
          expect(page).to have_checked_field(rule_options[0].name)
          expect(page).to have_unchecked_field(rule_options[1].name)
        end

        it "スポット詳細ページへのリンクがある" do
          expect(find(".page-link-wrap")).to have_link("スポットのページへ戻る", href: spot_path(spot))
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end

      describe "更新内容の入力", js: true do
        context "入力内容が妥当なとき" do
          include_context "有効な更新内容の入力"

          it "確認ページへ遷移する" do
            expect(current_path).to eq(edit_confirm_spot_path(spot))
          end
        end

        context "入力内容が不正なとき" do
          before do
            sign_in user
            visit spot_path(spot)
            click_link "スポットの情報を更新"
            fill_in "spot_name_input", with: nil
            fill_in "spot_address_input", with: nil
            page.execute_script("document.getElementById('spot_lat_input').value = null")
            page.execute_script("document.getElementById('spot_lng_input').value = null")
            fill_in "spot_official_site_input", with: nil
            check rule_options[1].name
            click_button "入力内容の確認へ"
          end

          it "バリデーションエラーが表示される" do
            expect(page).to have_content("#{Spot.human_attribute_name(:name)}を入力してください")
            expect(page).to have_content("#{Spot.human_attribute_name(:address)}を入力してください")
          end

          it "addressカラムにエラーがあるとき、latitudeカラム、longitudeカラムのバリデーションエラーは表示されない" do
            expect(page).not_to have_content("#{Spot.human_attribute_name(:latitude)}を入力してください")
            expect(page).not_to have_content("#{Spot.human_attribute_name(:longitude)}を入力してください")
          end

          it "チェックを追加した同伴ルールには、そのままチェックが付く" do
            expect(page).to have_checked_field(rule_options[1].name)
          end

          it_behaves_like "displays_all_categories"
          it_behaves_like "displays_all_allowed_areas"
          it_behaves_like "displays_all_option_titles"
          it_behaves_like "displays_all_rule_options"
        end
      end
    end

    describe "入力内容確認ページ", js: true do
      include_context "有効な更新内容の入力"

      describe "確認ページの表示" do
        it "入力した内容が表示される" do
          expect(page).to have_content(updated_spot.name)
          expect(page).to have_content(updated_spot.address)
          expect(page).to have_content(categories[1].name)
          expect(page).to have_content(allowed_areas[1].area)
          expect(page).to have_content(updated_spot.official_site)
          expect(page).to have_content(rule_options[1].name)
          expect(page).not_to have_content(rule_options[0].name)
        end

        it "入力画面に戻るボタンがある" do
          expect(page).to have_button("入力画面に戻る")
        end
      end

      describe "更新の完了" do
        it "スポットを更新できる" do
          expect { click_button "更新を完了する"}.to change { Spot.count }.by(0)
          spot.reload
          expect(spot.name).to eq(updated_spot.name)
          expect(spot.latitude).to eq(updated_spot.latitude)
          expect(spot.longitude).to eq(updated_spot.longitude)
          expect(spot.address).to eq(updated_spot.address)
          expect(spot.official_site).to eq(updated_spot.official_site)
          expect(spot.allowed_area_id).to eq(allowed_areas[1].id)
          expect(spot.category_id).to eq(categories[1].id)
          expect(spot.prefecture_id).to eq(prefecture.id)
        end

        it "スポットに紐づく同伴ルールを更新できる" do
          expect { click_button "更新を完了する"}.to change { Rule.count }.by(0)
          spot.reload
          expect(spot.rules.find_by(rule_option_id: rule_options[1].id).answer).to eq("1")
          expect(spot.rules.find_by(rule_option_id: rule_options[0].id).answer).to eq("0")
        end
      end
    end

    describe "入力内容の訂正ページ", js: true do
      include_context "有効な更新内容の入力"

      before { click_button "入力画面に戻る" }

      describe "戻った入力画面の表示" do
        it "入力欄に、最初に入力した内容が入っている" do
          expect(find("#spot_name_input").value).to eq(updated_spot.name)
          expect(find("#spot_lat_input", visible: false).value.to_f).to eq(updated_spot.latitude)
          expect(find("#spot_lng_input", visible: false).value.to_f).to eq(updated_spot.longitude)
          expect(find("#spot_address_input").value).to eq(updated_spot.address)
          expect(find("#spot_official_site_input").value).to eq(updated_spot.official_site)
          expect(page).to have_select("スポットカテゴリー", selected: categories[1].name)
          expect(page).to have_select("同伴可能エリア", selected: allowed_areas[1].area)
          expect(page).to have_checked_field(rule_options[1].name)
          expect(page).to have_unchecked_field(rule_options[0].name)
        end

        it_behaves_like "displays_all_categories"
        it_behaves_like "displays_all_allowed_areas"
        it_behaves_like "displays_all_option_titles"
        it_behaves_like "displays_all_rule_options"
      end
    end
  end

  describe "スポットの検索", js: true do
    let!(:spot) { create(:spot, :real_spot) }

    before do
      sign_in user
      visit root_path
      click_link "スポットを登録する"
    end

    context "マップに存在する特定の場所を検索したとき" do
      before do
        fill_in "spot_search_input", with: spot.name
        click_button "search_button"
        sleep 0.2
      end

      it "所在地・緯度経度が自動で入力される" do
        expect(find("#spot_address_input").value).to eq(spot.address)
        expect(find("#spot_lat_input", visible: false).value).to eq(spot.latitude.to_s)
        expect(find("#spot_lng_input", visible: false).value).to eq(spot.longitude.to_s)
      end
    end

    context "結果が出ない場所の検索" do
      shared_examples "display_alert" do
        it "アラートが表示される" do
          fill_in "spot_search_input", with: search_spot_name
          click_button "search_button"

          expect(page.accept_alert).to eq(alert_message)
        end
      end

      context "マップに存在しない場所を検索したとき" do
        let(:search_spot_name) { "non_existent_spot" }
        let(:alert_message) { "該当するスポットがありませんでした。" }

        it_behaves_like "display_alert"
      end

      context "空文字で検索したとき" do
        let(:search_spot_name) { "" }
        let(:alert_message) { "検索ワードを入力してください。" }

        it_behaves_like "display_alert"
      end

      context "マップに存在するが、特定ができない場所を検索したとき" do
        let(:search_spot_name) { "東京" }
        let(:alert_message) { "スポットを特定できませんでした。検索ワードを変更してください。" }

        it_behaves_like "display_alert"
      end

      context "2度目の検索で検索結果が出ない場合" do
        before do
          fill_in "spot_search_input", with: spot.name
          click_button "search_button"
          sleep 0.1
          fill_in "spot_search_input", with: ""
          page.accept_confirm { click_button "search_button" }
          sleep 0.1
        end

        it "住所、緯度、経度の値がクリアされる" do
          expect(find("#spot_address_input").value).to eq("")
          expect(find("#spot_lat_input", visible: false).value).to eq("")
          expect(find("#spot_lng_input", visible: false).value).to eq("")
        end
      end
    end
  end
end
