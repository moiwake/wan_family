require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "LikeImages", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached) }
  let!(:blob) { image.files.blobs.first }

  before { sign_in user }

  describe "POST /create" do
    let(:new_like_image) { LikeImage.last }

    subject { post spot_image_like_images_path(spot, image), params: { blob_id: blob.id }, xhr: true }

    it "画像にいいねを登録できる" do
      expect { subject }.to change { LikeImage.count }.by(1)
      expect(new_like_image.user_id).to eq(user.id)
      expect(new_like_image.image_id).to eq(image.id)
      expect(new_like_image.blob_id).to eq(blob.id)
    end

    it_behaves_like "returns http success"
  end

  describe "DELETE /destroy" do
    let!(:like_image) { create(:like_image, user_id: user.id, image_id: image.id, blob_id: blob.id) }

    subject { delete spot_image_like_image_path(spot, image, like_image), params: { blob_id: blob.id }, xhr: true }

    it "画像のいいねを削除できる" do
      expect { subject }.to change { LikeImage.count }.by(-1)
    end

    it_behaves_like "returns http success"
  end
end
