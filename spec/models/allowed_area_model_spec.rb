require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe AllowedArea, type: :model do
  let!(:allowed_area) { create(:allowed_area) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { allowed_area }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:allowed_area, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "areaカラム" do
      let(:attribute) { :area }

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

    context "areaカラムが重複しているとき" do
      let(:attribute) { :area }
      let(:invalid_object) { build(:allowed_area, area: allowed_area.area) }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end

  describe "scope#order_default" do
    before { create_list(:allowed_area, 3) }

    it "レシーバーのモデルのレコードを、idの昇順に並べ替えて返す" do
      expect(AllowedArea.order_default).to eq(AllowedArea.order(:id))
    end
  end
end
