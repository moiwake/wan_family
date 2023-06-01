require 'rails_helper'

RSpec.describe SpotFavoriteHelper, type: :helper do
  describe "#favorite?" do
    let(:spot_favorite) { create(:spot_favorite) }

    context "引数に渡したSpotFavoriteのレコードが存在する、かつDBに保存されているとき" do
      it "trueを返す" do
        expect(helper.favorite?(spot_favorite)).to eq(true)
      end
    end

    context "引数がnilのとき" do
      it "falseを返す" do
        expect(helper.favorite?(nil)).to eq(false)
      end
    end

    context "引数に渡したSpotFavoriteのレコードがDBに保存されていないとき" do
      before { spot_favorite.destroy }

      it "falseを返す" do
        expect(helper.favorite?(spot_favorite)).to eq(false)
      end
    end
  end
end
