require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
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
    end
  end
end

