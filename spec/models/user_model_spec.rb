require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { user }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:user, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "emailカラム" do
      let(:attribute) { :email }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "pasawordカラム" do
      let(:attribute) { :password }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムのデータが重複しているとき" do
      let(:invalid_object) { build(:user, name: user.name) }
      let(:attribute) { :name }

      it_behaves_like "バリデーションエラーメッセージ"
    end

    context "emailカラムが重複しているとき" do
      let(:invalid_object) { build(:user, email: user.email) }
      let(:attribute) { :email }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end

  context "パスワードに関するバリデーション" do
    let(:attribute) { :password }

    context "６文字未満のとき" do
      let(:invalid_object) { build(:user, password: "ab012") }
      let(:message) { "は6文字以上で入力してください" }

      it_behaves_like "バリデーションエラーメッセージ"
    end

    context "英字のみのとき" do
      let(:invalid_object) { build(:user, password: "abcdef") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "バリデーションエラーメッセージ"
    end

    context "数字のみのとき" do
      let(:invalid_object) { build(:user, password: "012345") }
      let(:message) { "は英字と数字の両方を含めて設定してください" }

      it_behaves_like "バリデーションエラーメッセージ"
    end
  end

  describe "content_typeのバリデーション" do
    let(:invalid_object) { create(:user) }
    let(:message) { "のファイル形式が不正です。" }

    context "human_avatarカラム" do
      let(:attribute) { :human_avatar }

      context "filesカラムに不正な形式のファイルを添付したとき" do
        before do
          invalid_object.human_avatar.attach({ io: File.open('spec/fixtures/test.txt'), filename: 'test.txt' })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "dog_avatarカラム" do
      let(:attribute) { :dog_avatar }

      context "filesカラムに不正な形式のファイルを添付したとき" do
        before do
          invalid_object.dog_avatar.attach({ io: File.open('spec/fixtures/test.txt'), filename: 'test.txt' })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "size_rangeのバリデーション" do
    let(:invalid_object) { create(:user) }

    context "human_avatarカラム" do
      let(:attribute) { :human_avatar }

      context "filesカラムに1バイト以下のファイルを添付したとき" do
        let(:message) { "を1バイト以上のサイズにしてください。" }

        before do
          invalid_object.human_avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "filesカラムに5メガバイト以上のファイルを添付したとき" do
        let(:message) { "を5MB以下のサイズにしてください。" }

        before do
          invalid_object.human_avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
          invalid_object.human_avatar.blob.assign_attributes({ byte_size: 6.megabytes })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "dog_avatarカラム" do
      let(:attribute) { :dog_avatar }

      context "filesカラムに1バイト以下のファイルを添付したとき" do
        let(:message) { "を1バイト以上のサイズにしてください。" }

        before do
          invalid_object.dog_avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "filesカラムに5メガバイト以上のファイルを添付したとき" do
        let(:message) { "を5MB以下のサイズにしてください。" }

        before do
          invalid_object.dog_avatar.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
          invalid_object.dog_avatar.blob.assign_attributes({ byte_size: 6.megabytes })
        end

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "#guest" do
    context "ゲストユーザー用のメールアドレスが登録されたUserレコードが存在するとき" do
      let!(:guest_user) { create(:user, email: "guest@example.com") }

      it "ゲストユーザーのUserレコードを返す" do
        expect(User.guest).to eq(guest_user)
      end
    end

    context "ゲストユーザー用のメールアドレスが登録されたUserレコードが存在するとき" do
      let(:guest_user_email) { "guest@example.com" }

      it "ゲストユーザーのUserレコードを作成して返す" do
        expect(User.guest.email).to eq(guest_user_email)
      end
    end
  end
end
