require 'rails_helper'

RSpec.describe SpotTagsDecorator, type: :decorator do
  before { stub_const("SpotTag::MAX_DISPLAY_NUMBER", 3) }

  describe "#exceed_max?" do
    context "スポットに関連するSpotTagレコード群が上限数より大きいとき" do
      let(:spot_tags) { SpotTag.all }

      before { FactoryBot.create_list(:spot_tag, 4) }

      it "trueを返す" do
        expect(spot_tags.decorate.exceed_max?).to eq(true)
      end
    end

    context "スポットに関連するSpotTagレコード群が上限数より小さいとき" do
      let(:spot_tags) { SpotTag.all }

      before { FactoryBot.create_list(:spot_tag, 2) }

      it "falseを返す" do
        expect(spot_tags.decorate.exceed_max?).to eq(false)
      end
    end
  end

  describe "#difference_of_max" do
    context "スポットに関連するSpotTagレコード群が上限数より大きいとき" do
      let(:spot_tags) { SpotTag.all }

      before { FactoryBot.create_list(:spot_tag, 4) }

      it "スポットに関連するSpotTagレコードと上限数との差分を返す" do
        expect(spot_tags.decorate.difference_of_max).to eq(1)
      end
    end
  end
end
