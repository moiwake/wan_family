require 'rails_helper'

RSpec.describe Region, type: :model do
  let!(:region) { create(:region) }

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:region, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "name_romaカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:region, name: region.name) }

      it_behaves_like "バリデーションエラーメッセージ"
    end

    context "name_romaカラムが重複しているとき" do
      let(:attribute) { :name_roma }
      let(:invalid_object) { build(:region, name_roma: region.name_roma) }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end
end
