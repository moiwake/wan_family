require 'rails_helper'

RSpec.describe "SpotFavoritesSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "スポットのお気に入り登録", js: true do
    context "ログインしているとき" do
      before do
        sign_in user
        visit spot_path(spot)
      end

      context "ログインユーザーがスポットをお気に入り登録していないとき" do
        it "スポットのお気に入り登録ができる" do
          expect do
            find("#add-favorite").click
            expect(page).to have_selector("#remove-favorite")
          end.to change { SpotFavorite.count }.by(1)

          expect(SpotFavorite.last.user_id).to eq(user.id)
          expect(SpotFavorite.last.spot_id).to eq(spot.id)
        end
      end

      context "ログインユーザーがスポットをお気に入り登録しているとき" do
        let!(:spot_favorite) { create(:spot_favorite, user: user, spot: spot) }

        before { visit spot_path(spot) }

        it "スポットのお気に入り登録を削除できる" do
          expect do
            find("#remove-favorite").click
            expect(page).to have_selector("#add-favorite")
          end.to change { SpotFavorite.count }.by(-1)
        end
      end
    end

    context "ログインしていないとき" do
      before { visit spot_path(spot) }

      it "ログインページへのリンクが表示される" do
        expect(find(".mark-spot-btns-wrap")).to have_link(href: new_user_session_path)
      end

      it "マウスオーバーすると、メッセージが表示される" do
        find('.mark-spot-btns-wrap').hover
        expect(page).to have_content("ログインが\n必要です")
      end
    end
  end
end
