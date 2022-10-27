require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
    invalid_rule_option.valid?
    expect(invalid_rule_option.errors[attribute]).to include(message)
  end
end

RSpec.describe RuleOption, type: :model do
  let!(:rule_option) { create(:rule_option) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(rule_option).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_rule_option) { build(:rule_option, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end

    context "option_titleカラム" do
      let(:attribute) { :option_title }

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
      let(:invalid_rule_option) { build(:rule_option, name: rule_option.name) }

      it_behaves_like "validation error message"
    end
  end
end
