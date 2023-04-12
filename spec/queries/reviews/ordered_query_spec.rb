require 'rails_helper'

RSpec.describe Reviews::OrderedQuery, type: :model do
  let(:scope) { Review.all }
  let(:ordered_query_instance) { Reviews::OrderedQuery.new(scope: scope, parent_record: nil, order_params: order_params, like_class: "ReviewHelpfulness") }

  describe "#order_scope" do
    subject(:return_value) { ordered_query_instance.send(:order_scope) }

    context "order_paramsハッシュのbyキーがspot_nameのとき" do
      let(:order_params) { { by: "spot_name" } }
      let(:ordered_scope) { scope.where(spot_id: [spot1.id, spot2.id]).order([Arel.sql("field(reviews.spot_id, ?)"), [spot1.id, spot2.id]]) }
      let!(:spot1) { create(:spot, name: "spot1") }
      let!(:spot2) { create(:spot, name: "spot2") }

      before do
        create(:review, spot: spot2)
        create(:review, spot: spot1)
      end

      it "レシーバーのレコード群を、関連するSpotレコードのnameカラムの昇順に並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end
  end
end
