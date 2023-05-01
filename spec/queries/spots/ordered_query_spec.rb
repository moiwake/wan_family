require 'rails_helper'

RSpec.describe Spots::OrderedQuery, type: :model do
  let(:scope) { Spot.all }
  let(:ordered_query_instance) { Spots::OrderedQuery.new(scope: scope, parent_record: nil, order_params: order_params, like_class: "SpotFavorite") }
  let!(:spot1) { create(:spot) }
  let!(:spot3) { create(:spot) }
  let!(:spot2) { create(:spot) }

  describe "#order_asc_or_desc" do
    subject(:return_value) { ordered_query_instance.send(:order_asc_or_desc) }

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがdescのとき" do
      let(:order_params) { { by: "created_at", direction: "desc" } }
      let(:ordered_scope) do
        scope.where(id: [spot2.id, spot3.id, spot1.id]).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), [spot2.id, spot3.id, spot1.id]])
      end

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの降順に、Spotレコードを並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがascのとき" do
      let(:order_params) { { by: "created_at", direction: "asc" } }
      let(:ordered_scope) do
        scope.where(id: [spot1.id, spot3.id, spot2.id]).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), [spot1.id, spot3.id, spot2.id]])
      end

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの昇順に、Spotレコードを並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end
  end

  describe "#order_default" do
    subject(:return_value) { ordered_query_instance.send(:order_default) }

    context "order_paramsハッシュが空のとき" do
      let(:order_params) { {} }
      let(:ordered_scope) do
        scope.where(id: [spot2.id, spot3.id, spot1.id]).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), [spot2.id, spot3.id, spot1.id]])
      end

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの降順に、Spotレコードを並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end
  end
end
