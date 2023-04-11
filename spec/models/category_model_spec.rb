require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe Category, type: :model do
  let!(:category) { create(:category) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { category }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:category, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:category, name: category.name) }

      it_behaves_like "adds validation error messages"
    end
  end

  describe "scope#order_default" do
    before { create_list(:allowed_area, 3) }

    it "レシーバーのモデルのレコードを、idの昇順に並べ替えて返す" do
      expect(Category.order_default).to eq(Category.order(:id))
    end
  end
end
