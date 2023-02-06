require 'rails_helper'

RSpec.describe "LikeImagesSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached, spot_id: spot.id) }
  let(:blob) { image.files.blobs.first }

  let!(:like_images) { create_list(:like_image, 3, image_id: image.id, blob_id: blob.id) }
  let!(:like_count) { LikeImage.where(blob_id: blob.id).count }

  describe "画像のCute登録" do
    before do
      visit spot_images_path(spot)
      find("#blob_#{blob.id}").click
    end

    it "画像に登録されているCuteの総計を表示する" do
      expect(find("#post-image-like")).to have_content(like_count)
    end

    context "ログインしているとき" do
      let!(:before_like_count) { like_count }

      before { sign_in user }

      context "ログインユーザーが画像にCuteを登録していないとき" do
        let(:new_like) { LikeImage.last }

        it "画像にCuteの登録ができる" do
          expect do
            find("#add-image-like").click
            expect(find("#post-image-like")).to have_content(before_like_count + 1)
          end.to change { LikeImage.count }.by(1)

          expect(new_like.user_id).to eq(user.id)
          expect(new_like.image_id).to eq(image.id)
          expect(new_like.blob_id).to eq(blob.id)
        end
      end

      context "ログインユーザーが画像にCuteを登録しているとき" do
        let!(:like_image) { create(:like_image, user_id: user.id, image_id: image.id, blob_id: blob.id) }

        it "画像のCuteの登録を削除できる" do
          expect do
            find("#remove-image-like").click
            expect(find("#post-image-like")).to have_content(before_like_count)
          end.to change { LikeImage.count }.by(-1)
        end
      end

      context "ログインユーザーが投稿した画像のとき" do
        let(:image_poster) { User.find(image.user_id) }

        before { sign_in image_poster }

        it "Cute登録のリンクが表示されない" do
          expect(find("#post-image-like")).not_to have_selector("a")
        end
      end
    end

    context "ログインしていないとき" do
      it "ログインページへのリンクが表示される" do
        expect(find("#post-image-like")).to have_link(href: new_user_session_path)
      end
    end
  end
end
