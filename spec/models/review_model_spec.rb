require 'rails_helper'
require 'support/shared_examples/model_spec'

RSpec.describe Review, type: :model do
  let!(:review) { create(:review) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { review }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:review, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "titleカラム" do
      let(:attribute) { :title }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "commentカラム" do
      let(:attribute) { :comment }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "dog_scoreカラム" do
      let(:attribute) { :dog_score }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "human_scoreカラム" do
      let(:attribute) { :human_score }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "visit_dateカラム" do
      let(:attribute) { :visit_date }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "scope" do
    before { create_list(:review, 2, :with_image) }

    describe "scope#load_all_associations" do
      subject(:return_value) { Review.all.load_all_associations }

      it "関連する全てのモデルのテーブルをロードする" do
        expect(return_value.last.association(:user).loaded?).to eq(true)
        expect(return_value.last.association(:spot).loaded?).to eq(true)
        expect(return_value.last.association(:image).loaded?).to eq(true)
        expect(return_value.last.association(:review_helpfulnesses).loaded?).to eq(true)
        expect(return_value.last.image.association(:files_attachments).loaded?).to eq(true)
      end
    end

    describe "scope#load_active_storage_associations" do
      subject(:return_value) { Review.all.load_active_storage_associations }

      it "関連するActiveStorageのテーブルをロードする" do
        expect(return_value.last.association(:image).loaded?).to eq(true)
        expect(return_value.last.image.association(:files_attachments).loaded?).to eq(true)
        expect(return_value.last.image.files[0].association(:blob).loaded?).to eq(true)
        expect(return_value.last.image.files[0].blob.association(:variant_records).loaded?).to eq(true)
      end
    end
  end
end
