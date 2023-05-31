require 'rails_helper'

RSpec.describe RankedQueryBase, type: :model do
  let(:scope) do
    create(:review, review_helpfulnesses_count: 1)
    create(:review, review_helpfulnesses_count: 2)
    create(:review, review_helpfulnesses_count: 0)
    Review.all
  end
  let(:parent_record) { nil }
  let(:order_params) { { by: "assessment" } }
  let(:assessment_class) { "ReviewHelpfulness" }
  let!(:rank_num) { stub_const("RankedQueryBase::RANK_NUMBER", 1) }
  let(:child_class_instance) { RankedQueryBase.new(scope: scope, parent_record: nil, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num) }
  let(:child_class) { Class.new(RankedQueryBase) }

  describe "#call" do
    subject(:return_value) { child_class.call(scope: scope, parent_record: nil, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num) }

    let(:limited_scope) { double("scope") }

    before do
      allow(child_class).to receive(:new).and_return(child_class_instance)
      allow(child_class_instance).to receive(:limit_scope).and_return(limited_scope)
      subject
    end

    it "引数を渡して、child_classをレシーバーにnewメソッドを呼び出す" do
      expect(child_class).to have_received(:new).once.with(scope: scope, parent_record: nil, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num)
    end

    it "child_classのインスタンスをレシーバーに、limit_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:limit_scope).once
    end

    it "limit_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(limited_scope)
    end
  end

  describe "#limit_scope" do
    subject(:return_value) { child_class_instance.limit_scope }

    let(:limited_scope_ids) { ranked_scope.limit(rank_num).ids }
    let(:ranked_scope) { scope }

    before do
      allow(child_class_instance).to receive(:set_ordered_scope).and_return(ranked_scope)
      subject
    end

    it "child_classのインスタンスをレシーバーに、set_ordered_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_ordered_scope).once
    end

    it "set_ordered_scopeメソッドの返り値を指定の数に限定して返す" do
      expect(return_value.ids).to eq(limited_scope_ids)
    end
  end
end
