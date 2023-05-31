require 'rails_helper'

RSpec.describe Reviews::RankedQuery, type: :model do
  let(:scope) { Review.all }
  let(:parent_record) { nil }
  let(:assessment_class) { "ReviewHelpfulness" }
  let!(:rank_num) { stub_const("Reviews::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    before do
      allow(RankedQueryBase).to receive(:call)
      Reviews::RankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, assessment_class: assessment_class, rank_num: rank_num)
    end
  end
end
