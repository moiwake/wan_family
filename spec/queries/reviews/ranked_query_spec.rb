require 'rails_helper'

RSpec.describe Reviews::RankedQuery, type: :model do
  let(:ordered_scope) do
    create_list(:review, 3)
    Review.all
  end
  let(:limited_scope) { ordered_scope.limit(rank_num) }
  let!(:rank_num) { stub_const("Reviews::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    subject(:return_value) { Reviews::RankedQuery.call }

    before do
      allow(Reviews::OrderedQuery).to receive(:call).and_return(ordered_scope)
      allow(Reviews::RankedQuery).to receive(:limit_scope).and_return(limited_scope)
      subject
    end

    it "引数を渡して、limit_scopeメソッドを呼び出す" do
      expect(Reviews::RankedQuery).to have_received(:limit_scope).once.with(ordered_scope, rank_num)
    end

    it "Reviews::OrderedQueryに対して、指定した引数を渡してcallメソッドを実行する" do
      expect(Reviews::OrderedQuery).to have_received(:call).once.with(scope: nil, parent_record: nil, order_params: { by: "likes_count" })
    end

    it "limit_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(limited_scope)
    end
  end

  describe "#limit_scope" do
    subject(:return_value) { Reviews::RankedQuery.limit_scope(ordered_scope, rank_num) }

    it "引数に渡されたレコードを、指定の数に限定して返す" do
      expect(return_value).to eq(limited_scope)
    end
  end
end
