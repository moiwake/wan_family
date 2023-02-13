require 'rails_helper'

RSpec.describe OrderedQueryBase, type: :model do
  describe "#call" do
    let(:dummy_records) { create_list(:review, 3) }
    let(:scope) { dummy_records.first.class }

    subject { OrderedQueryBase.call(scope: scope, order_params: order_params) }

    context "引数のハッシュが空のとき" do
      let(:order_params) { {} }
      let(:ordered_scope) { scope.order(created_at: :desc, id: :desc) }

      it "引数のレコード群を降順にしたActiveRecord::Relationオブジェクトを返す" do
        expect(subject).to eq(ordered_scope)
      end
    end

    context "引数に渡されたハッシュが降順を示すとき" do
      let(:order_params) { { by: "created_at", direction: "desc" } }
      let(:ordered_scope) { scope.order(created_at: :desc, id: :desc) }

      it "引数のレコード群を降順にしたActiveRecord::Relationオブジェクトを返す" do
        expect(subject).to eq(ordered_scope)
      end
    end

    context "引数に渡されたハッシュが昇順を示すとき" do
      let(:order_params) { { by: "created_at", direction: "asc" } }
      let(:ordered_scope) { scope.order(created_at: :asc, id: :asc) }

      it "引数のレコード群を昇順にしたActiveRecord::Relationオブジェクトを返す" do
        expect(subject).to eq(ordered_scope)
      end
    end

    context "引数に渡されたハッシュがいいねが多い順を示すとき" do
      let(:order_params) { { by: "likes_count" } }
      let(:scope_ids) { [dummy_records[2].id, dummy_records[0].id] }
      let(:ordered_scope_ids) { [dummy_records[2].id, dummy_records[0].id, dummy_records[1].id] }

      before do
        FactoryBot.create_list(:like_review, 2, review_id: dummy_records[2].id )
        FactoryBot.create_list(:like_review, 1, review_id: dummy_records[0].id )
        allow(OrderedQueryBase).to receive(:set_ids_in_order_likes).and_return(scope_ids)
      end

      it "引数のレコード群をいいねが多い順にしたActiveRecord::Relationオブジェクトを返す" do
        expect(subject.class.name).to eq("ActiveRecord::Relation")
        expect(subject.pluck(:id)).to eq(ordered_scope_ids)
      end
    end
  end
end
