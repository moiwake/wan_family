require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe OptionTitle, type: :model do
  let!(:option_title) { create(:option_title) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { option_title }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:option_title, attribute => (type == :nil ? nil : "")) }
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
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:option_title, name: option_title.name) }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end

  describe "scope#order_default" do
    before { create_list(:allowed_area, 3) }

    it "レシーバーのモデルのレコードを、idの昇順に並べ替えて返す" do
      expect(OptionTitle.order_default).to eq(OptionTitle.order(:id))
    end
  end
end
