require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe RuleOption, type: :model do
  let!(:rule_option) { create(:rule_option) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { rule_option }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:rule_option, attribute => (type == :nil ? nil : "")) }
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

    context "option_titleカラム" do
      let(:attribute) { :option_title }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:rule_option, name: rule_option.name) }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end
end
