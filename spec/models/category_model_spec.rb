require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
    invalid_category.valid?
    expect(invalid_category.errors[attribute]).to include(message)
  end
end

RSpec.describe Category, type: :model do
  let!(:category) { create(:category) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(category).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_category) { build(:category, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_category) { build(:category, name: category.name) }

      it_behaves_like "validation error message"
    end
  end
end
