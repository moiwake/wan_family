require 'rails_helper'

RSpec.describe ImageBlobs::RankedQuery, type: :model do
  let(:ordered_scope) { create(:image, :attached).files_blobs }
  let(:limited_scope) { ordered_scope.limit(rank_num) }
  let!(:rank_num) { stub_const("ImageBlobs::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    subject(:return_value) { ImageBlobs::RankedQuery.call }

    before do
      allow(ImageBlobs::OrderedQuery).to receive(:call).and_return(ordered_scope)
      allow(ImageBlobs::RankedQuery).to receive(:limit_scope).and_return(limited_scope)
      subject
    end

    it "引数を渡して、limit_scopeメソッドを呼び出す" do
      expect(ImageBlobs::RankedQuery).to have_received(:limit_scope).once.with(ordered_scope, rank_num)
    end

    it "ImageBlobs::OrderedQueryに対して、指定した引数を渡してcallメソッドを実行する" do
      expect(ImageBlobs::OrderedQuery).to have_received(:call).once.with(scope: nil, parent_record: nil, order_params: { by: "likes_count" })
    end

    it "limit_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(limited_scope)
    end
  end

  describe "#limit_scope" do
    subject(:return_value) { ImageBlobs::RankedQuery.limit_scope(ordered_scope, rank_num) }

    it "引数に渡されたレコードを、指定の数に限定して返す" do
      expect(return_value).to eq(limited_scope)
    end
  end
end
