require 'rails_helper'

RSpec.describe SpotTagHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "#tagged?" do
    before { allow(helper).to receive(:current_user).and_return(user) }

    context "引数に渡したSpotレコードのidと、ログインユーザーのidを持つSpotTagレコードが存在するとき" do
      let!(:spot_tag) { create(:spot_tag, user_id: user.id, spot_id: spot.id) }

      it "trueを返す" do
        expect(helper.tagged?(spot)).to eq(true)
      end
    end

    context "引数に渡したSpotレコードのidと、ログインユーザーのidを持つSpotTagレコードが存在しないとき" do
      it "falseを返す" do
        expect(helper.tagged?(spot)).to eq(false)
      end
    end
  end

  describe "#exceed_max?" do
    context "引数に渡したSpotTagのレコード群が、MAX_DISPLAY_NUMBERを上回るとき" do
      let!(:spot_tags) { create_list(:spot_tag, 4, user_id: user.id, spot_id: spot.id) }

      it "trueを返す" do
        expect(helper.exceed_max?(spot_tags)).to eq(true)
      end
    end

    context "引数に渡したSpotTagのレコード群が、MAX_DISPLAY_NUMBERを上回るとき" do
      let!(:spot_tags) { create_list(:spot_tag, 2, user_id: user.id, spot_id: spot.id) }

      it "falseを返す" do
        expect(helper.exceed_max?(spot_tags)).to eq(false)
      end
    end
  end

  describe "#difference_of_max" do
    let!(:spot_tags) { create_list(:spot_tag, 4, user_id: user.id, spot_id: spot.id) }

    it "引数に渡したSpotTagのレコード群と、MAX_DISPLAY_NUMBERとの差分を返す" do
      expect(helper.difference_of_max(spot_tags)).to eq(1)
    end
  end
end
