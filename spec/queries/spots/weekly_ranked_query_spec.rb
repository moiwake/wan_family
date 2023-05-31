require 'rails_helper'

RSpec.describe Spots::WeeklyRankedQuery, type: :model do
  let!(:scope) { Spot.all }
  let!(:parent_record) { nil }
  let!(:assessment_class) { "Impression" }
  let!(:date) { "days" }
  let(:period_num) { stub_const("Spots::WeeklyRankedQuery::PERIOD_NUMBER", 6) }

  describe "#call" do
    before do
      allow(RankedForSpecificPeriodQuery).to receive(:call)
      Spots::WeeklyRankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedForSpecificPeriodQuery).to have_received(:call).once.with(scope: scope, parent_record: parent_record, assessment_class: assessment_class, date: date, number: period_num)
    end
  end
end
