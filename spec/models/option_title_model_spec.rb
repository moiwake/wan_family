require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
    invalid_option_title.valid?
    expect(invalid_option_title.errors[attribute]).to include(message)
  end
end

RSpec.describe OptionTitle, type: :model do
  let!(:option_title) { create(:option_title) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(option_title).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_option_title) { build(:option_title, attribute => (type == :nil ? nil : "")) }
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
      let(:invalid_option_title) { build(:option_title, name: option_title.name) }

      it_behaves_like "validation error message"
    end
  end
end

