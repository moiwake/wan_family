require 'rails_helper'

RSpec.describe Spots::RankedQuery, type: :model do
  let(:scope) { Spot.all }
  let(:parent_record) { nil }
  let(:assessment_class) { "SpotFavorite" }
  let!(:rank_num) { stub_const("Spots::RankedQuery::RANK_NUMBER", 1) }

  describe "#call" do
    before do
      allow(RankedQueryBase).to receive(:call)
      Spots::RankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, assessment_class: assessment_class, rank_num: rank_num)
    end
  end
end
