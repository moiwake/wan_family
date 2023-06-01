require 'rails_helper'

RSpec.describe ReviewDecorator, type: :decorator do
  describe "#get_files_ordered_by_blob_creation_date" do
    context "レシーバーがDBに保存されている、かつリロードしたレシーバーに関連するImageレコードが存在するとき" do
      let!(:review) { create(:review) }
      let!(:image) { create(:image, :attached, review: review) }
      let!(:ordered_file_ids) { [image.files[1].id, image.files[0].id] }

      it "Blobレコードの作成日順、同じ場合はid順に並んだFileレコードを返す" do
        expect(review.decorate.get_files_ordered_by_blob_creation_date.ids).to eq(ordered_file_ids)
      end
    end

    context "レシーバーがDBに保存されていないとき" do
      let!(:review) { build(:review) }
      let!(:image) { build(:image, :attached, review_id: review.id) }

      it "空の配列を返す" do
        expect(review.decorate.get_files_ordered_by_blob_creation_date).to eq([])
      end
    end

    context "リロードしたレシーバーに関連するImageレコードが存在しないとき" do
      let!(:review) { build(:review) }

      it "空の配列を返す" do
        expect(review.decorate.get_files_ordered_by_blob_creation_date).to eq([])
      end
    end
  end
end
