require 'rails_helper'

RSpec.describe Reviews::OrderedQuery, type: :model do
  let(:scope) { Review.all }
  let(:parent_record) { nil }
  let(:order_params) { {} }
  let(:assessment_class) { "ReviewHelpfulness" }
  let(:class_instance) { Reviews::OrderedQuery.new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class) }

  describe "#call" do
    before do
      allow(OrderedQueryBase).to receive(:call)
      Reviews::OrderedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(OrderedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end
  end

  describe "#order_scope" do
    subject(:return_value) { class_instance.send(:order_scope) }

    context "order_paramsハッシュのbyキーがspot_nameのとき" do
      let(:order_params) { { by: "spot_name" } }
      let(:ordered_scope_ids) { [review3.id, review1.id, review2.id] }
      let!(:review1) { create(:review, spot: spot2) }
      let!(:review2) { create(:review, spot: spot3) }
      let!(:review3) { create(:review, spot: spot1) }
      let!(:spot1) { create(:spot, name: "spot1") }
      let!(:spot2) { create(:spot, name: "spot2") }
      let!(:spot3) { create(:spot, name: "spot3") }

      it "レシーバーのレコード群を、関連するSpotレコードのnameカラムの昇順に並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end
  end
end
