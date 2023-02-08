require 'rails_helper'

RSpec.describe FavoriteSpotHelper, type: :helper do
  describe "#favorite?" do
    let(:favorite_spot) { create(:favorite_spot) }

    context "引数に渡したFavoriteSpotのレコードが存在するとき" do
      it "trueを返す" do
        expect(helper.favorite?(favorite_spot)).to eq(true)
      end
    end

    context "引数がnilのとき" do
      it "falseを返す" do
        expect(helper.favorite?(nil)).to eq(false)
      end
    end

    context "引数に渡したFavoriteSpotのレコードが削除されているとき" do
      before { favorite_spot.destroy }

      it "falseを返す" do
        expect(helper.favorite?(favorite_spot)).to eq(false)
      end
    end
  end
end
