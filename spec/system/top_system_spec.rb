require 'rails_helper'

RSpec.describe "TopSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:categories) { create_list(:category, 3) }
  let!(:allowed_areas) { create_list(:allowed_area, 3) }

  describe "トップページの表示" do
    context "ログインしていないとき" do
      before { visit root_path }

      it "新規登録ページへのリンクがある" do
        expect(page).to have_link("新規登録", href: new_user_registration_path)
      end

      it "ログインページへのリンクがある" do
        expect(page).to have_link("ログイン", href: new_user_session_path)
      end
    end

    context "一般ユーザーがログインしているとき" do
      before do
        sign_in user
        visit root_path
      end

      it "マイページページへのリンクがある" do
        expect(page).to have_link("マイページ", href: mypage_path)
      end

      it "ログアウトのリンクがある" do
        expect(page).to have_link("ログアウト", href: destroy_user_session_path)
      end

      it "スポット新規登録ページのリンクがある" do
        expect(page).to have_link("新しいお出かけスポットの登録", href: new_spot_path)
      end
    end

    context "管理者がログインしているとき" do
      before do
        sign_in admin
        visit root_path
      end

      it "サイト管理ページへのリンクがある" do
        expect(page).to have_link("サイト管理ページへ", href: rails_admin_path)
      end
    end
  end

  describe "スポットの検索" do
    before { visit root_path }

    describe "条件検索" do
      let!(:spot) do
        create(:spot, name: "東京ドッグパーク", address: "東京都新宿区", category_id: categories[0].id, allowed_area_id: allowed_areas[0].id)
      end

      describe "詳細検索" do
        before do
          fill_in "q_and_name_or_address_cont", with: "ドッグパーク"
          check categories[0].name
          check allowed_areas[0].area
          select "東京都", from: "都道府県で絞る"
          click_button "検索"
        end

        it "検索条件に合ったスポットを検索できる" do
          expect(page).to have_link(spot.name, href: spot_path(spot.id))
          expect(page).to have_content(spot.address)
          expect(page).to have_content(spot.category.name)
        end

        it "検索した条件が検索欄に入力されている" do
          expect(find("#q_and_name_or_address_cont").value).to eq("ドッグパーク")
          expect(page).to have_checked_field(categories[0].name)
          expect(page).to have_checked_field(allowed_areas[0].area)
          expect(page).to have_select("都道府県で絞る", selected: "東京都")
        end
      end

      describe "エリア検索" do
        before { click_link "関東" }

        it "選択したエリアに属するスポットを検索できる" do
          expect(page).to have_link(spot.name, href: spot_path(spot.id))
          expect(page).to have_content(spot.address)
          expect(page).to have_content(spot.category.name)
        end
      end

      describe "検索結果ページからの検索" do
        before do
          click_button "検索"
          fill_in "q_and_name_or_address_cont", with: "ドッグパーク"
          check categories[0].name
          check allowed_areas[0].area
          select "東京都", from: "都道府県で絞る"
          click_button "検索"
        end

        it "検索条件に合ったスポットを検索できる" do
          expect(page).to have_link(spot.name, href: spot_path(spot.id))
          expect(page).to have_content(spot.address)
          expect(page).to have_content(spot.category.name)
        end
      end
    end

    describe "マップ検索", js: true do
      let!(:spots) { create_list(:spot, 3) }
      let(:markers) { page.all("area", visible: false) }

      before do
        click_link "お出かけスポット一覧"
      end

      it "マップに登録したスポットの数だけマーカーが表示される" do
        expect(markers.length).to eq(3)
      end

      it "マーカーをクリックすると、スポット詳細ページのリンクがある情報ウィンドウが表示される" do
        expect do
          page.execute_script("document.getElementsByTagName('area')[0].click();")
        end.to change { page.all(".gm-style-iw-t").length }.by(1)

        expect(page.all(".gm-style-iw-t")[0]).to have_link(spots[0].name, href: spot_path(spots[0]))
      end
    end
  end
end
