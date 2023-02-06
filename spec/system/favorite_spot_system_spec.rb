require 'rails_helper'

RSpec.describe "FavoriteSpotsSystemSpecs", type: :system do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:favorite_spots) { create_list(:favorite_spot, 3, spot_id: spot.id) }
  let!(:favorite_count) { FavoriteSpot.where(spot_id: spot.id).size }

  before { visit spot_path(spot) }

  describe "スポットのお気に入り登録" do
    it "スポットに登録されているお気に入りの総計を表示する" do
      expect(find(".post-favorite")).to have_content(favorite_count)
    end

    context "ログインしているとき", js: true do
      let!(:before_favorite_count) { favorite_count }

      before do
        sign_in user
        visit spot_path(spot)
      end

      context "ログインユーザーがスポットをお気に入り登録していないとき" do
        it "スポットのお気に入り登録ができる" do
          expect do
            find("#add-favorite").click
            expect(find(".post-favorite")).to have_content(before_favorite_count + 1)
          end.to change { FavoriteSpot.count }.by(1)

          expect(FavoriteSpot.last.user_id).to eq(user.id)
          expect(FavoriteSpot.last.spot_id).to eq(spot.id)
        end
      end

      context "ログインユーザーがスポットをお気に入り登録しているとき" do
        let!(:favorite_spot) { create(:favorite_spot, user_id: user.id, spot_id: spot.id) }

        it "スポットのお気に入り登録を削除できる" do
          expect do
            find("#remove-favorite").click
            expect(find(".post-favorite")).to have_content(before_favorite_count - 1)
          end.to change { FavoriteSpot.count }.by(-1)
        end
      end
    end

    context "ログインしていないとき" do
      it "お気に入り登録のリンクが表示されない" do
        expect(find(".post-favorite")).not_to have_selector("a")
      end
    end
  end
end
