require 'rails_helper'

RSpec.describe ImageBlobs::WeeklyRankedQuery, type: :model do
  let(:scope) { nil }
  let(:parent_record) { Image.all }
  let(:assessment_class) { "ImageLike" }
  let(:date) { "days" }
  let(:period_num) { stub_const("ImageBlobs::WeeklyRankedQuery::PERIOD_NUMBER", 6) }

  describe "#call" do
    before do
      allow(RankedForSpecificPeriodQuery).to receive(:call)
      ImageBlobs::WeeklyRankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedForSpecificPeriodQuery).to have_received(:call).once.with(scope: scope, parent_record: parent_record, assessment_class: assessment_class, date: date, number: period_num)
    end
  end
end
