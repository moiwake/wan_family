require "rails_helper"
require 'support/shared_examples'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context "全カラムのデータが有効なとき" do
    it "そのユーザーデータは有効" do
      expect(user).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:user, attribute => (type == :nil ? nil : "")) }
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

    context "pasawordカラム" do
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

    context "nameカラムのデータが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:user, name: user.name) }

      it_behaves_like "adds validation error messages"
    end

    context "emailカラムが重複しているとき" do
      let(:attribute) { :email }
      let(:invalid_object) { build(:user, email: user.email) }

      it_behaves_like "adds validation error messages"
    end
  end

  context "パスワードに関するバリデーション" do
    let(:attribute) { :password }

    context "６文字未満のとき" do
      let(:invalid_object) { build(:user, password: "ab012") }
      let(:message) { "は6文字以上で入力してください" }

      it_behaves_like "adds validation error messages"
    end

    context "英字のみのとき" do
      let(:invalid_object) { build(:user, password: "abcdef") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "adds validation error messages"
    end

    context "数字のみのとき" do
      let(:invalid_object) { build(:user, password: "012345") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "adds validation error messages"
    end
  end
end
