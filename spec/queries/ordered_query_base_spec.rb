require 'rails_helper'

RSpec.describe OrderedQueryBase, type: :model do
  let(:scope) do
    create_list(:review, 3)
    Review.all
  end
  let(:parent_record) { nil }
  let(:order_params) { {} }
  let(:assessment_class) { "ReviewHelpfulness" }
  let(:child_class_instance) { ChildClass.new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class) }
  let(:child_class) { Class.new(OrderedQueryBase) }

  before { stub_const("ChildClass", child_class) }

  describe "#call" do
    subject(:return_value) { ChildClass.call(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class) }

    let(:ordered_scope) { instance_double("scope") }

    before do
      allow(ChildClass).to receive(:new).and_return(child_class_instance)
      allow(child_class_instance).to receive(:set_ordered_scope).and_return(ordered_scope)
      subject
    end

    it "引数を渡して、ChildClassをレシーバーにnewメソッドを呼び出す" do
      expect(ChildClass).to have_received(:new).once.with(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
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
      let(:scope_ids) { [scope[0].id, scope[1].id, scope[2].id] }

      it "重複を除いたscopeを返す" do
        expect(return_value.ids).to eq(scope_ids)
      end
    end

    context "parent_recordがnilではないとき" do
      context "parent_recordが複数のレコードであれば" do
        let(:parent_record) { Spot.where(id: [scope[0].spot_id, scope[1].spot_id]) }
        let(:scope_ids) { [scope[0].id, scope[1].id] }

        it "parent_recordのidを外部キーに持つscopeのレコード群を返す" do
          expect(return_value.ids).to eq(scope_ids)
        end
      end

      context "parent_recordが単一のレコードであれば" do
        let(:parent_record) { Spot.find(scope[0].spot_id) }
        let(:scope_ids) { [scope[0].id] }

        it "parent_recordのidを外部キーに持つscopeのレコードを返す" do
          expect(return_value.ids).to eq(scope_ids)
        end
      end
    end
  end

  describe "#order_scope" do
    subject(:return_value) { child_class_instance.send(:order_scope) }

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがdescのとき" do
      let(:order_params) { { by: "created_at", direction: "desc" } }
      let(:ordered_scope_ids) { [scope[2].id, scope[1].id, scope[0].id] }

      it "scopeのレコード群を、created_atカラム、idカラムの降順に並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end

    context "order_paramsハッシュのbyキーがcreated_at、directionキーがascのとき" do
      let(:order_params) { { by: "created_at", direction: "asc" } }
      let(:ordered_scope_ids) { [scope[0].id, scope[1].id, scope[2].id] }

      it "scopeのレコード群を、created_atカラム、idカラムの昇順に並び替える" do
        expect(return_value.ids).to eq(ordered_scope_ids)
      end
    end

    context "order_paramsハッシュのbyキーがassessmentのとき" do
      let(:order_params) { { by: "assessment" } }

      context "scopeのモデルに対して、assessment_classのモデルのカウンタキャッシュが有効ならば" do
        let(:scope) do
          create(:review, review_helpfulnesses_count: 1)
          create(:review, review_helpfulnesses_count: 2)
          create(:review, review_helpfulnesses_count: 0)
          Review.all
        end
        let(:ordered_scope_ids) { [scope[1].id, scope[0].id, scope[2].id] }

        it "scopeのレコード群を、scopeのカウンタキャッシュのカラムの値が多い順に並び替える" do
          expect(return_value.ids).to eq(ordered_scope_ids)
        end
      end

      context "scopeのモデルに対して、assessment_classのモデルのカウンタキャッシュが有効ではないならば" do
        let(:ordered_scope_ids) { [scope[1].id, scope[2].id, scope[0].id] }

        before do
          create_list(:review_helpfulness, 2, review_id: scope[1].id)
          create_list(:review_helpfulness, 1, review_id: scope[2].id)
        end

        it "scopeのレコード群を、評価クラスに登録されている外部キーが多い順に並び替える" do
          expect(return_value.ids).to eq(ordered_scope_ids)
        end
      end
    end

    context "order_paramsハッシュが空のとき" do
      let(:order_params) { {} }

      context "scopeのレコードの属性にupdated_atカラムが含まれていれば" do
        let(:ordered_scope_ids) { [scope[1].id, scope[2].id, scope[0].id] }

        before { scope[1].update(updated_at: (Time.current + 1)) }

        it "scopeのレコード群を、updated_atカラム、created_atカラム、idカラムの降順に並び替える" do
          expect(return_value.ids).to eq(ordered_scope_ids)
        end
      end

      context "scopeのレコードの属性にupdated_atカラムが含まれていれば" do
        let(:scope) { create(:image, :attached).files_blobs }
        let(:assessment_class) { "ImageLike" }
        let(:ordered_scope_ids) { [scope[1].id, scope[0].id] }

        it "scopeのレコード群を、created_atカラム、idカラムの降順に並び替える" do
          expect(return_value.ids).to eq(ordered_scope_ids)
        end
      end
    end
  end
end
