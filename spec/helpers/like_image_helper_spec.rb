require 'rails_helper'

RSpec.describe LikeImageHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:image) { create(:image, :attached, user_id: user.id) }
  let(:blob) { image.files.first.blob }

  describe "#image_posted_by_another?" do
    context "引数に渡したレコードの親となるImageレコードのuser_idと、ログインユーザーのidが異なるとき" do
      before { allow(helper).to receive(:current_user).and_return(another_user) }

      it "trueを返す" do
        expect(helper.image_posted_by_another?(blob)).to eq(true)
      end
    end

    context "引数に渡したレコードの親となるImageレコードのuser_idと、ログインユーザーのidが同じとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it "falseを返す" do
        expect(helper.image_posted_by_another?(blob)).to eq(false)
      end
    end
  end

  describe "#image_liked?" do
    context "ログインユーザーが存在するとき" do
      before { allow(helper).to receive(:current_user).and_return(another_user) }

      context "引数に渡したBlobレコードのidを持つLikeImageレコードが存在するとき" do
        let!(:like_image) { create(:like_image, user_id: anothe_user.id, image_id: image.id, blob_id: blob.id) }

        it "trueを返す" do
          expect(helper.image_liked?(blob)).to eq(true)
        end
      end

      context "引数に渡したBlobレコードのidを持つLikeImageレコードが存在しないとき" do
        it "falseを返す" do
          expect(helper.image_liked?(blob)).to eq(false)
        end
      end
    end

    context "ログインユーザーが存在しないとき" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "falseを返す" do
        expect(helper.image_liked?(blob)).to eq(false)
      end
    end
  end

  describe "#get_image_likes_count" do
    let!(:like_image_0) { create(:like_image, user_id: user.id, image_id: image.id, blob_id: blob.id) }
    let!(:like_image_1) { create(:like_image, user_id: another_user.id, image_id: image.id, blob_id: blob.id) }

    it "引数に渡したBlobレコードのidを持つ、LikeImageレコードの数を返す" do
      expect(helper.get_image_likes_count(blob)).to eq(2)
    end
  end
end
