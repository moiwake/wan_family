require 'rails_helper'

RSpec.describe ImageLikeHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:image) { create(:image, :attached, user_id: user.id) }
  let(:image_blob) { image.files_blobs[0] }

  describe "#image_blob_posted_by_another?" do
    context "引数に渡したBlobレコードに関連するImageレコードのuser_idカラムが、ログインユーザーのidと異なるとき" do
      let!(:another_user) { create(:user) }

      before { allow(helper).to receive(:current_user).and_return(another_user) }

      it "trueを返す" do
        expect(helper.image_blob_posted_by_another?(image_blob)).to eq(true)
      end
    end

    context "引数に渡したBlobレコードに関連するImageレコードのuser_idカラムが、ログインユーザーのidと同じとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it "falseを返す" do
        expect(helper.image_blob_posted_by_another?(image_blob)).to eq(false)
      end
    end
  end

  describe "#image_liked?" do
    let!(:image_like) { create(:image_like, image_id: image.id, blob_id: image_blob.id) }

    context "引数に渡したImageLikeのレコードが存在するとき" do
      it "trueを返す" do
        expect(helper.image_liked?(image_like)).to eq(true)
      end
    end

    context "引数がnilのとき" do
      it "falseを返す" do
        expect(helper.image_liked?(nil)).to eq(false)
      end
    end

    context "引数に渡したImageLikeのレコードがDBに保存されていないとき" do
      before { image_like.destroy }

      it "falseを返す" do
        expect(helper.image_liked?(image_like)).to eq(false)
      end
    end
  end

  describe "#count_image_blob_likes?" do
    before { create_list(:image_like, 3, image_id: image.id, blob_id: image_blob.id) }

    it "引数に渡したBlobレコードのidと、blob_idカラムの値が同じImageLikeレコードの数を返す" do
      expect(helper.count_image_blob_likes(image_blob)).to eq(3)
    end
  end
end
