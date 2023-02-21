require 'rails_helper'

RSpec.describe SpotsForRankQuery, type: :model do
  describe "#call" do
    before { FactoryBot.create_list(:spot, 2) }

    context "引数なしでcallメソッドを呼び出すとき" do
      let(:spots_for_rank_query_instance) { SpotsForRankQuery.new(default_arguments) }
      let(:default_arguments) { { scope: Spot.all, rank_class: "FavoriteSpot" } }

      before do
        allow(SpotsForRankQuery).to receive(:new).and_return(spots_for_rank_query_instance)
        SpotsForRankQuery.call
      end

      it "デフォルト値を引数に渡して、newメソッドを呼び出す" do
        expect(SpotsForRankQuery).to have_received(:new).once.with(default_arguments)
      end
    end
  end
end
