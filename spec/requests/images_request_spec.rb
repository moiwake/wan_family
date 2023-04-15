require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Images", type: :request do
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached) }
  let!(:image_blob) { image.files_blobs[0] }

  describe "GET /index" do
    before do
      create(:spot_history, spot: spot)
      get spot_images_path(spot)
    end

    it_behaves_like "returns http success"
  end

  describe "GET /show" do
    before { get spot_image_path(spot, image), params: { image_blob_id: image_blob.id }, xhr: true }

    it_behaves_like "returns http success"
  end
end

