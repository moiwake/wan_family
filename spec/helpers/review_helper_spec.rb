require 'rails_helper'

RSpec.describe ReviewHelper, type: :helper do
  describe "#get_files_for_edit" do
    context "引数に渡したReviewレコードが存在するとき" do
      let!(:review) { create(:review) }
      let!(:image) { create(:image, :attached, review_id: review.id) }
      let!(:ordered_files) { image.files.eager_load(:blob).order("blob.created_at desc, blob.id desc") }

      it "Blobレコードの作成日順、同じ場合はid順に並んだFileレコードを返す" do
        expect(helper.get_files_for_edit(review)).to eq(ordered_files)
      end
    end

    context "引数に渡したReviewレコードがnilのとき" do
      it "nilを返す" do
        expect(helper.get_files_for_edit(nil)).to eq(nil)
      end
    end

    context "引数に渡したReviewレコードがDBに保存されていないとき" do
      let!(:review) { build(:review) }

      it "nilを返す" do
        expect(helper.get_files_for_edit(review)).to eq(nil)
      end
    end

  end
end
