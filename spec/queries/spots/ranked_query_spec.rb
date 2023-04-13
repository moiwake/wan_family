require 'rails_helper'

RSpec.describe Spots::RankedQuery, type: :model do
  let(:ordered_scope) do
    create_list(:spot, 3)
    Spot.all
  end
  let(:limited_scope) { ordered_scope.limit(rank_num) }
  let!(:rank_num) { stub_const("Spots::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    subject(:return_value) { Spots::RankedQuery.call }

    before do
      allow(Spots::OrderedQuery).to receive(:call).and_return(ordered_scope)
      allow(Spots::RankedQuery).to receive(:limit_scope).and_return(limited_scope)
      subject
    end

    it "引数を渡して、limit_scopeメソッドを呼び出す" do
      expect(Spots::RankedQuery).to have_received(:limit_scope).once.with(ordered_scope, rank_num)
    end

    it "Spots::OrderedQueryに対して、指定した引数を渡してcallメソッドを実行する" do
      expect(Spots::OrderedQuery).to have_received(:call).once.with(scope: nil, parent_record: nil, order_params: { by: "likes_count" })
    end

    it "limit_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(limited_scope)
    end
  end

  describe "#limit_scope" do
    subject(:return_value) { Spots::RankedQuery.limit_scope(ordered_scope, rank_num) }

    it "引数に渡されたレコードを、指定の数に限定して返す" do
      expect(return_value).to eq(limited_scope)
    end
  end
end
