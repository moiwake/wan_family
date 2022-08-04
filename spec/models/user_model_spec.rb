require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
    invalid_user.valid?
    expect(invalid_user.errors[attribute]).to include(message)
  end
end

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context "全カラムのデータが有効なとき" do
    it "そのユーザーデータは有効" do
      expect(user).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_user) { build(:user, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "user_nameカラム" do
      let(:attribute) { :user_name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "emailカラム" do
      let(:attribute) { :email }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "pasawordカラム" do
      let(:attribute) { :password }

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

    context "user_nameカラムのデータが重複しているとき" do
      let(:attribute) { :user_name }
      let(:invalid_user) { build(:user, :duplicate_user_name) }

      it_behaves_like "validation error message"
    end

    context "emailカラムが重複しているとき" do
      let(:attribute) { :email }
      let(:invalid_user) { build(:user, :duplicate_email) }

      it_behaves_like "validation error message"
    end
  end

  context "パスワードに関するバリデーション" do
    let(:attribute) { :password }

    context "６文字未満のとき" do
      let(:invalid_user) { build(:user, password: "ab012") }
      let(:message) { "は6文字以上で入力してください" }

      it_behaves_like "validation error message"
    end

    context "英字のみのとき" do
      let(:invalid_user) { build(:user, password: "abcdef") }
      let(:message) { "パスワードには英字と数字の両方を含めて設定してください" }

      it_behaves_like "validation error message"
    end

    context "数字のみのとき" do
      let(:invalid_user) { build(:user, password: "012345") }
      let(:message) { "パスワードには英字と数字の両方を含めて設定してください" }

      it_behaves_like "validation error message"
    end
  end
end
