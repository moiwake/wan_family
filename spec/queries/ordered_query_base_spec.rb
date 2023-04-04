require 'rails_helper'

RSpec.describe OrderedQueryBase, type: :model do
  let(:scope) { create_list(:review, 3)[0].class.all }
  let(:child_class_instance) { ChildClass.new(arguments) }
  let(:arguments) { { scope: scope, parent_record: parent_record, order_params: order_params, like_class: "ReviewHelpfulness" } }
  let(:parent_record) { instance_double("spot") }
  let(:order_params) { {} }

  before(:all) { ChildClass = Class.new(OrderedQueryBase) }

  describe "#call" do
    let(:ordered_scope) { instance_double("scope") }

    subject(:return_value) { ChildClass.call(arguments) }

    before do
      allow(ChildClass).to receive(:new).and_return(child_class_instance)
      allow(child_class_instance).to receive(:set_ordered_scope).and_return(ordered_scope)
      subject
    end

    it "引数を渡して、ChildClassをレシーバーにnewメソッドを呼び出す" do
      expect(ChildClass).to have_received(:new).once.with(arguments)
    end

    it "ChildClassのインスタンスをレシーバーに、set_ordered_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_ordered_scope).once
    end

    it "set_ordered_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(ordered_scope)
    end
  end

  describe "#set_ordered_scope" do
    before do
      allow(child_class_instance).to receive(:set_scope)
      allow(child_class_instance).to receive(:order_scope)
      child_class_instance.set_ordered_scope
    end

    it "set_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_scope).once
    end

    it "order_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:order_scope).once
    end
  end

  describe "#set_scope" do
    subject(:return_value) { child_class_instance.send(:set_scope) }

    context "parent_recordがnilのとき" do
      let(:parent_record) { nil }

      it "scopeを返す" do
        expect(return_value).to eq(scope)
      end
    end

    context "parent_recordがnilではないとき" do
      let(:parent_record) { Spot.where(id: [scope[0].spot_id, scope[1].spot_id]) }

      it "parent_recordと関連するscopeを返す" do
        expect(return_value).to eq(scope.where(spot_id: parent_record.ids))
      end
    end
  end

  describe "#order_scope" do
    subject(:return_value) { child_class_instance.send(:order_scope) }

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがdescのとき" do
      let(:order_params) { { by: "created_at", direction: "desc" } }
      let(:ordered_scope) { scope.order(created_at: :desc, id: :desc) }

      it "レシーバーのレコード群を、created_atカラム、idカラムの降順に並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがascのとき" do
      let(:order_params) { { by: "created_at", direction: "asc" } }
      let(:ordered_scope) { scope.order(created_at: :asc, id: :asc) }

      it "レシーバーのレコード群を、created_atカラム、idカラムの昇順に並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end

    context "order_paramsハッシュのbyキーがlikes_countのとき" do
      let(:order_params) { { by: "likes_count" } }
      let(:ordered_scope_ids) { [scope[1].id, scope[2].id, scope[0].id] }
      let(:ordered_scope) { scope.where(id: ordered_scope_ids).order([Arel.sql("field(reviews.id, ?)"), ordered_scope_ids]) }

      before do
        FactoryBot.create_list(:review_helpfulness, 2, review_id: scope[1].id)
        FactoryBot.create_list(:review_helpfulness, 1, review_id: scope[2].id)
      end

      it "レシーバーのレコード群を、好評価が多い順に並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end

    context "order_paramsハッシュが空のとき" do
      let(:order_params) { {} }
      let(:ordered_scope) { scope.order(created_at: :desc, id: :desc) }

      it "レシーバーのレコード群を、created_atカラム、idカラムの降順に並び替える" do
        expect(return_value).to eq(ordered_scope)
      end
    end
  end
end
