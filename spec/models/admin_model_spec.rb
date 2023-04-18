require 'rails_helper'
require 'support/shared_examples/model_spec'

RSpec.describe Admin, type: :model do
  let!(:admin) { create(:admin) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { admin }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:admin, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "emailカラム" do
      let(:attribute) { :email }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "passwordカラム" do
      let(:attribute) { :password }

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

    context "emailカラムが重複しているとき" do
      let(:attribute) { :email }
      let(:invalid_object) { build(:admin, email: admin.email) }

      it_behaves_like "adds validation error messages"
    end
  end

  describe "パスワードに関するバリデーション" do
    let(:attribute) { :password }

    context "６文字未満のとき" do
      let(:invalid_object) { build(:admin, password: "ab012") }
      let(:message) { "は6文字以上で入力してください" }

      it_behaves_like "adds validation error messages"
    end

    context "英字のみのとき" do
      let(:invalid_object) { build(:admin, password: "abcdef") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "adds validation error messages"
    end

    context "数字のみのとき" do
      let(:invalid_object) { build(:admin, password: "012345") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "adds validation error messages"
    end
  end
end
