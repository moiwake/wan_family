require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe SpotHistory, type: :model do
  let!(:spot_history) { create(:spot_history) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { spot_history }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot_history, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "historyカラム" do
      let(:attribute) { :history }

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
end
