require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe OptionTitle, type: :model do
  let!(:option_title) { create(:option_title) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { option_title }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:option_title, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

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

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:option_title, name: option_title.name) }

      it_behaves_like "adds validation error messages"
    end
  end
end

