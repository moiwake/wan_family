require 'rails_helper'

RSpec.describe Reviews::LimitedRankedPresenter, type: :model do
  let(:ranked_scope) { instance_double("ranked_scope") }

  describe "#call" do
    subject(:return_value) { Reviews::LimitedRankedPresenter.call }

    before do
      allow(Reviews::RankedQuery).to receive(:call).and_return(ranked_scope)
      subject
    end

    it "Reviews::RankedQueryに対して、指定した引数を渡してcallメソッドを実行する" do
      expect(Reviews::RankedQuery).to have_received(:call).once.with(scope: nil, parent_record: nil, rank_num: nil)
    end

    it "Reviews::RankedQueryに対するcallメソッドの返り値を返す" do
      expect(return_value).to eq(ranked_scope)
    end
  end
end
