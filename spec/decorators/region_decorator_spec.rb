require 'rails_helper'

RSpec.describe RegionDecorator, type: :decorator do
  let!(:region) { create(:region) }
  let!(:prefecture) { create(:prefecture, region: region) }

  describe "#spot_total" do
    before { FactoryBot.create_list(:spot, 3, prefecture: prefecture) }

    it "レシーバーに属するスポットの数を返す" do
      expect(region.decorate.spot_total).to eq(3)
    end
  end
end
