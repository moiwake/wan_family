require 'rails_helper'

RSpec.describe Spots::OrderedQuery, type: :model do
  let(:scope) { Spot.all }
  let(:parent_record) { nil }
  let(:order_params) { {} }
  let(:assessment_class) { "SpotFavorite" }
  let(:ordered_query_instance) { Spots::OrderedQuery.new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class) }
  let!(:spot1) { create(:spot) }
  let!(:spot2) { create(:spot) }
  let!(:spot3) { create(:spot) }

  describe "#call" do
    before do
      allow(OrderedQueryBase).to receive(:call)
      Spots::OrderedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(OrderedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end
  end

  describe "#order_asc_or_desc" do
    subject(:return_value) { ordered_query_instance.send(:order_asc_or_desc) }

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがdescのとき" do
      let(:order_params) { { by: "created_at", direction: "desc" } }
      let(:ordered_scope_ids) { [spot3.id, spot2.id, spot1.id] }

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの降順に、Spotレコード群を並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがascのとき" do
      let(:order_params) { { by: "created_at", direction: "asc" } }
      let(:ordered_scope_ids) { [spot1.id, spot2.id, spot3.id] }

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの昇順に、Spotレコードを並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end
  end

  describe "#order_default" do
    subject(:return_value) { ordered_query_instance.send(:order_default) }

    context "order_paramsハッシュが空のとき" do
      let(:order_params) { {} }
      let(:ordered_scope_ids) { [spot3.id, spot2.id, spot1.id] }

      it "関連するSpotHistoryのレコードのcreated_atカラム、idカラムの降順に、Spotレコードを並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end
  end
end
