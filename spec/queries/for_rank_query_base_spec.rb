require 'rails_helper'

RSpec.describe ForRankQueryBase, type: :model do
  let(:arguments) { { scope: scope, rank_class: "FavoriteSpot" } }
  let(:child_class_instance) { ChildClass.new(arguments) }

  before(:all) { ChildClass = Class.new(ForRankQueryBase) }

  describe "#call" do
    let(:scope) { instance_double("scope") }
    let(:ranked_scope) { instance_double("ranked_scope") }

    subject(:return_value) { ChildClass.call(arguments) }

    before do
      allow(ChildClass).to receive(:new).and_return(child_class_instance)
      allow(child_class_instance).to receive(:set_ranked_scope).and_return(ranked_scope)
      subject
    end

    it "引数を渡して、ChildClassをレシーバーにnewメソッドを呼び出す" do
      expect(ChildClass).to have_received(:new).once.with(arguments)
    end

    it "ChildClassのインスタンスをレシーバーに、set_ranked_scopeメソッドを呼び出す" do
      expect(child_class_instance).to have_received(:set_ranked_scope).once
    end

    it "set_ranked_scopeメソッドの返り値を返す" do
      expect(return_value).to eq(ranked_scope)
    end
  end

  describe "#set_ranked_scope" do
    let(:scope) { create_list(:spot, 4)[0].class.all }
    let(:ranked_scope_ids) { [scope[1].id, scope[2].id, scope[0].id] }
    let(:ranked_scope) { scope.where(id: ranked_scope_ids).order([Arel.sql("field(spots.id, ?)"), ranked_scope_ids]) }

    subject(:return_value) { child_class_instance.set_ranked_scope }

    before do
      stub_const("ForRankQueryBase::RANKING_DISPLAY_NUMBER", 3)
      FactoryBot.create_list(:favorite_spot, 3, spot_id: scope[1].id)
      FactoryBot.create_list(:favorite_spot, 2, spot_id: scope[2].id)
      FactoryBot.create_list(:favorite_spot, 1, spot_id: scope[0].id)
    end

    it "好評価順に並べたidを持つscopeのレコード群を、上限個数分、順番どおりに返す" do
      expect(return_value).to eq(ranked_scope)
      expect(return_value.size).to eq(ForRankQueryBase::RANKING_DISPLAY_NUMBER)
    end
  end
end

