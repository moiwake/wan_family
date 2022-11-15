require "rails_helper"

shared_examples "validation error message" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_rule.valid?
    expect(invalid_rule.errors[attribute]).to include(message)
  end
end

RSpec.describe Rule, type: :model do
  let!(:rule) { create(:rule) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(rule).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_rule) { build(:rule, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end

    context "rule_optionカラム" do
      let(:attribute) { :rule_option }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end

    context "answerカラム" do
      let(:attribute) { :answer }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "spotカラムとrule_optionカラムの両データが重複しているとき" do
      let(:attribute) { :spot }
      let(:invalid_rule) { build(:rule, spot: rule.spot, rule_option: rule.rule_option) }

      it_behaves_like "validation error message"
    end

    context "spotカラムのデータのみが重複しているとき" do
      let(:attribute) { :spot }
      let(:valid_rule) { build(:rule, spot: rule.spot) }

      it "そのスポットデータは有効" do
        expect(valid_rule).to be_valid
      end
    end

    context "rule_optionカラムがのみ重複しているとき" do
      let(:attribute) { :rule_option }
      let(:valid_rule) { build(:rule, rule_option: rule.rule_option) }

      it "そのスポットデータは有効" do
        expect(valid_rule).to be_valid
      end
    end
  end
end

