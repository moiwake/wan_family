require 'rails_helper'

RSpec.describe Spots::WeeklyRankedQuery, type: :model do
  let(:period_num) { stub_const("Spots::WeeklyRankedQuery::PERIOD_NUMBER", 6) }

  describe "#call" do
    before do
      create_list(:spot, 2)
      allow(RankedForSpecificPeriodQuery).to receive(:call)
      Spots::WeeklyRankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedForSpecificPeriodQuery).to have_received(:call).once.with(scope: Spot.all, parent_record: nil, assessment_class: "Impression", date: "days", number: period_num)
    end
  end
end
