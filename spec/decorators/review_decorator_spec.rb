require 'rails_helper'

RSpec.describe ReviewDecorator, type: :decorator do
  describe "#get_files_for_edit" do
    context "レシーバーがDBに保存されている、かつリロードしたレシーバーに関連するImageレコードが存在するとき" do
      let!(:review) { create(:review) }
      let!(:image) { create(:image, :attached, review_id: review.id) }
      let!(:ordered_files) { image.files.eager_load(:blob).order("blob.created_at desc, blob.id desc") }

      it "Blobレコードの作成日順、同じ場合はid順に並んだFileレコードを返す" do
        expect(review.decorate.get_files_for_edit).to eq(ordered_files)
      end
    end

    context "レシーバーがDBに保存されていないとき" do
      let!(:review) { build(:review) }
      let!(:image) { build(:image, :attached, review_id: review.id) }

      it "空の配列を返す" do
        expect(review.decorate.get_files_for_edit).to eq([])
      end
    end

    context "リロードしたレシーバーに関連するImageレコードが存在しないとき" do
      let!(:review) { build(:review) }

      it "空の配列を返す" do
        expect(review.decorate.get_files_for_edit).to eq([])
      end
    end
  end
end
