require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe Rule, type: :model do
  let!(:rule) { create(:rule) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { rule }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:rule, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "rule_optionカラム" do
      let(:attribute) { :rule_option }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "answerカラム" do
      let(:attribute) { :answer }

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

    context "spotカラムとrule_optionカラムの両データが重複しているとき" do
      let(:attribute) { :spot }
      let(:invalid_object) { build(:rule, spot: rule.spot, rule_option: rule.rule_option) }

      it_behaves_like "adds validation error messages"
    end

    context "spotカラムのデータのみが重複しているとき" do
      let(:attribute) { :spot }
      let(:valid_object) { build(:rule, spot: rule.spot) }

      it_behaves_like "the object is valid"
    end

    context "rule_optionカラムがのみ重複しているとき" do
      let(:attribute) { :rule_option }
      let(:valid_object) { build(:rule, rule_option: rule.rule_option) }

      it_behaves_like "the object is valid"
    end
  end
end

