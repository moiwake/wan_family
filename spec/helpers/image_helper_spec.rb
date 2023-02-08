require 'rails_helper'

RSpec.describe ImageHelper, type: :helper do
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached, spot_id: spot.id) }
  let(:blob) { image.files.first.blob }

  describe "#image_link_params_hash" do
    it "引数に渡したBlobレコードに応じて、ハッシュを返す" do
      expect(helper.image_link_params_hash(blob)).to eq({ spot_id: spot.id, id: image.id, blob_id: blob.id })
    end
  end

  describe "#get_parent_image" do
    it "引数に渡したBlobレコードの親となるImageレコードを返す" do
      expect(helper.get_parent_image(blob)).to eq(image)
    end
  end
end
