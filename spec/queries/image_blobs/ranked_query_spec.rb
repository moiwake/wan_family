require 'rails_helper'

RSpec.describe ImageBlobs::RankedQuery, type: :model do
  let(:scope) { nil }
  let(:parent_record) { Image.all }
  let(:assessment_class) { "ImageLike" }
  let!(:rank_num) { stub_const("ImageBlobs::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    before do
      allow(RankedQueryBase).to receive(:call)
      ImageBlobs::RankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, assessment_class: assessment_class, rank_num: rank_num)
    end
  end
end
