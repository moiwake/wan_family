require 'rails_helper'
require 'support/shared_examples/model_spec'

RSpec.describe Review, type: :model do
  let!(:review) { create(:review) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { review }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:review, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "titleカラム" do
      let(:attribute) { :title }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "commentカラム" do
      let(:attribute) { :comment }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "dog_scoreカラム" do
      let(:attribute) { :dog_score }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "human_scoreカラム" do
      let(:attribute) { :human_score }

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
end
