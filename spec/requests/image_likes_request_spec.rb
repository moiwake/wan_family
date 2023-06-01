require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "ImageLikes", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached) }
  let!(:image_blob) { image.files_blobs[0] }

  before { sign_in user }

  describe "POST /create" do
    subject { post spot_image_image_likes_path(spot, image), params: { image_blob_id: image_blob.id }, xhr: true }

    let(:new_like_image) { ImageLike.last }

    it "画像にいいねを登録できる" do
      expect { subject }.to change { ImageLike.count }.by(1)
      expect(new_like_image.user_id).to eq(user.id)
      expect(new_like_image.image_id).to eq(image.id)
      expect(new_like_image.blob_id).to eq(image_blob.id)
    end

    it_behaves_like "HTTPリクエストの成功"
  end

  describe "DELETE /destroy" do
    subject { delete spot_image_image_like_path(spot, image, image_like), params: { image_blob_id: image_blob.id }, xhr: true }

    let!(:image_like) { create(:image_like, user: user, image: image, blob_id: image_blob.id) }

    it "画像のいいねを削除できる" do
      expect { subject }.to change { ImageLike.count }.by(-1)
    end

    it_behaves_like "HTTPリクエストの成功"
  end
end
