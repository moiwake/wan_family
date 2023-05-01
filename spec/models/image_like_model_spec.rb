require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe ImageLike, type: :model do
  let!(:image) { create(:image, :attached) }
  let!(:blob) { image.files_blobs[0] }
  let!(:image_like) { create(:image_like, image: image, blob_id: blob.id) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { image_like }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:image_like, attribute => nil) }
    let(:message) { "を入力してください" }

    context "user_idカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end

    context "image_idカラム" do
      let(:attribute) { :image }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end

    context "blob_idカラム" do
      let(:attribute) { :blob_id }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとblob_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:image_like, user_id: image_like.user_id, blob_id: image_like.blob_id) }

      it_behaves_like "adds validation error messages"
    end

    context "user_idカラムのみが重複しているとき" do
      let!(:another_blob) { image.files_blobs[1] }
      let(:valid_object) { build(:image_like, user_id: image_like.user_id, blob_id: another_blob.id) }

      it_behaves_like "the object is valid"
    end

    context "blob_idカラムのみが重複しているとき" do
      let!(:another_user) { create(:user) }
      let(:valid_object) { build(:image_like, user_id: another_user.id, blob_id: image_like.blob_id) }

      it_behaves_like "the object is valid"
    end
  end

  describe "image_like_user_id_validatorのバリデーション" do
    let(:message) { "投稿者が自分の画像に「いいね」を登録することはできません。" }

    context "レコードのimage_idを持つImageレコードのuser_idと、レコードのuser_idが同じとき" do
      let!(:user) { create(:user) }
      let!(:image_by_user) { create(:image, :attached, user: user) }
      let!(:invalid_object) { build(:image_like, image: image_by_user, user: user) }
      let(:attribute) { :user }

      it_behaves_like "adds validation error messages"
    end
  end
end
