require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { user }

    it_behaves_like "the object is valid"
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
      let(:invalid_object) { build(:user, name: user.name) }
      let(:attribute) { :name }

      it_behaves_like "adds validation error messages"
    end

    context "emailカラムが重複しているとき" do
      let(:invalid_object) { build(:user, email: user.email) }
      let(:attribute) { :email }

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

  describe "content_typeのバリデーション" do
    let(:invalid_object) { create(:user) }
    let(:message) { "のファイル形式が不正です。" }
    let(:attribute) { :avatar }

    context "filesカラムに不正な形式のファイルを添付したとき" do
      before do
        invalid_object.avatar.attach({ io: File.open('spec/fixtures/test.txt'), filename: 'test.txt' })
      end

      it_behaves_like "adds validation error messages"
    end
  end

  describe "size_rangeのバリデーション" do
    let(:invalid_object) { create(:user) }
    let(:attribute) { :avatar }

    context "filesカラムに1バイト以下のファイルを添付したとき" do
      let(:message) { "を1バイト以上のサイズにしてください。" }

      before do
        invalid_object.avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
      end

      it_behaves_like "adds validation error messages"
    end

    context "filesカラムに5メガバイト以上のファイルを添付したとき" do
      let(:message) { "を5MB以下のサイズにしてください。" }

      before do
        invalid_object.avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
        invalid_object.avatar.blob.assign_attributes({byte_size: 6.megabytes})
      end

      it_behaves_like "adds validation error messages"
    end
  end
end
