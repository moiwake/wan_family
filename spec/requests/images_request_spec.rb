require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Images", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached) }
  let!(:blob) { image.files.blobs.first }

  describe "GET /index" do
    before { get spot_images_path(spot.id) }

    it_behaves_like "returns http success"
  end

  describe "GET /show" do
    before { get spot_image_path(spot.id, image.id), params: { blob_id: blob.id }, xhr: true }

    it_behaves_like "returns http success"
  end
end

