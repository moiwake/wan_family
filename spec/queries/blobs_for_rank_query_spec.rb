require 'rails_helper'

RSpec.describe BlobsForRankQuery, type: :model do
  describe "#call" do
    before { FactoryBot.create_list(:image, 2, :attached) }

    context "引数なしでcallメソッドを呼び出すとき" do
      let(:blobs_for_rank_query_instance) { BlobsForRankQuery.new(default_arguments) }
      let(:default_arguments) { { scope: ActiveStorage::Blob.all, rank_class: "LikeImage" } }

      before do
        allow(BlobsForRankQuery).to receive(:new).and_return(blobs_for_rank_query_instance)
        BlobsForRankQuery.call
      end

      it "デフォルト値を引数に渡して、newメソッドを呼び出す" do
        expect(BlobsForRankQuery).to have_received(:new).once.with(default_arguments)
      end
    end
  end
end
