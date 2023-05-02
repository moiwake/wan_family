require 'rails_helper'

RSpec.describe RankedForSpecificPeriodQuery, type: :model do
  let!(:scope) do
    create_list(:spot, 3)
    Spot.all
  end
  let(:child_class_instance) { ChildClass.new(arguments) }
  let(:child_class) { Class.new(RankedForSpecificPeriodQuery) }
  let(:arguments) { { scope: scope, parent_record: nil, like_class: "SpotFavorite", date: "days", number: number } }
  let!(:number) { stub_const("RankedForSpecificPeriodQuery::PERIOD_NUMBER", 1) }
  let!(:rank_num) { stub_const("RankedForSpecificPeriodQuery::RANKING_NUMBER", 2) }

  before { stub_const("ChildClass", child_class) }

  describe "#call" do
    let(:ranked_scope) { instance_double("scope") }

    subject(:return_value) { ChildClass.call(arguments) }

    before do
      allow(child_class).to receive(:new).and_return(child_class_instance)
      allow(child_class_instance).to receive(:set_ranked_scope_for_specific_period).and_return(ranked_scope)
      subject
    end

    it "引数を渡して、ChildClassをレシーバーにnewメソッドを呼び出す" do
      expect(child_class).to have_received(:new).once.with(arguments)
    end

    it "ChildClassのインスタンスをレシーバーに、set_ranked_scope_for_specific_periodメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_ranked_scope_for_specific_period).once
    end

    it "set_ranked_scope_for_specific_periodメソッドの返り値を返す" do
      expect(return_value).to eq(ranked_scope)
    end
  end

  describe "#set_ranked_scope_for_specific_period" do
    before do
      allow(child_class_instance).to receive(:set_ordered_scope)
      allow(child_class_instance).to receive(:limit_scope)
      child_class_instance.set_ranked_scope_for_specific_period
    end

    it "set_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_ordered_scope).once
    end

    it "order_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:limit_scope).once
    end
  end

  describe "#limit_scope" do
    subject(:return_value) { child_class_instance.send(:limit_scope) }

    it "ランキングの数に限定したscopeのレコードを返す" do
      expect(return_value).to eq(scope.limit(rank_num))
    end
  end

  describe "#group_like_class_records" do
    subject(:return_value) { child_class_instance.send(:group_like_class_records) }

    context "set_grouped_like_class_recordsメソッドの返り値のレコード数が、ランキングの数以上のとき" do
      let(:grouped_like_class_records) { SpotFavorite.group(:spot_id) }

      before do
        allow(child_class_instance).to receive(:set_grouped_like_class_records).and_return(grouped_like_class_records)
        create_list(:spot_favorite, 2, spot: scope[2])
      end

      it "set_grouped_like_class_recordsメソッドの返り値をそのまま返す" do
        expect(return_value.select(:spot_id)).to eq(grouped_like_class_records.select(:spot_id))
      end
    end

    context "set_grouped_like_class_recordsメソッドの返り値のレコード数が、ランキングの数未満のとき" do
      let(:grouped_like_class_records) { SpotFavorite.group(:spot_id) }

      before do
        allow(child_class_instance).to receive(:set_grouped_like_class_records).and_return(grouped_like_class_records)
        allow(child_class_instance).to receive(:fill_records_up_to_rank_num).and_return(grouped_like_class_records)
        create(:spot_favorite, spot: scope[0])
        subject
      end

      it "fill_records_up_to_rank_numメソッドを5回まで呼び出す" do
        expect(child_class_instance).to have_received(:fill_records_up_to_rank_num).exactly(5).times
      end
    end
  end

  describe "#fill_records_up_to_rank_num" do
    before do
      allow(CreatedInSpecificPeriodQuery).to receive(:call).and_return(SpotFavorite.all)
      create(:spot_favorite, spot: scope[0])
      child_class_instance.send(:fill_records_up_to_rank_num)
    end

    it "指定の引数を渡して、CreatedInSpecificPeriodQueryクラスを呼び出す" do
      expect(CreatedInSpecificPeriodQuery).to have_received(:call).with(scope: SpotFavorite.all, date: "days", number: (number + (number + 1))
    end
  end
end
