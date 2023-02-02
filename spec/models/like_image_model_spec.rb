require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe LikeImage, type: :model do
  let!(:image) { create(:image, :attached) }
  let!(:blob) { image.files.blobs.first }
  let!(:another_blob) { image.files.blobs.last }
  let!(:like_image) { create(:like_image, image_id: image.id, blob_id: blob.id) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { like_image }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:like_image, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "user_idカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "image_idカラム" do
      let(:attribute) { :image }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "blob_idカラム" do
      let(:attribute) { :blob_id }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとblob_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:like_image, user_id: like_image.user_id, blob_id: like_image.blob_id) }

      it_behaves_like "adds validation error messages"
    end

    context "user_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:like_image, user_id: like_image.user_id, blob_id: another_blob.id) }

      it_behaves_like "the object is valid"
    end

    context "blob_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:like_image, blob_id: like_image.blob_id) }

      it_behaves_like "the object is valid"
    end
  end
end
