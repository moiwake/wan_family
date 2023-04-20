require 'rails_helper'

RSpec.describe "LikeImagesSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:image) { create(:image, :attached, spot: spot) }
  let(:image_blob) { image.files_blobs[0] }
  let!(:image_likes) { create_list(:image_like, 3, image: image, blob_id: image_blob.id) }
  let!(:current_like_count) { ImageLike.where(blob_id: image_blob.id).count }

  describe "画像のいいね登録" do
    it "画像に登録されているいいねの総計を表示する" do
      visit spot_images_path(spot)
      find("#image_blob_#{image_blob.id}").click
      expect(find(".image-like-btn-wrap")).to have_content(current_like_count)
    end

    context "ログインしているとき" do
      context "ログインユーザーがいいねを登録していないとき" do
        let!(:former_like_count) { ImageLike.where(blob_id: image_blob.id).count }
        let(:new_like) { ImageLike.last }

        before do
          sign_in user
          visit spot_images_path(spot)
          find("#image_blob_#{image_blob.id}").click
        end

        it "いいねの登録ができる" do
          expect do
            find(".add-like-image-btn").click
            expect(page).to have_selector(".remove-like-image-btn")
            expect(find(".image-like-btn-wrap")).to have_content(former_like_count + 1)
          end.to change { ImageLike.count }.by(1)

          expect(new_like.user_id).to eq(user.id)
          expect(new_like.image_id).to eq(image.id)
          expect(new_like.blob_id).to eq(image_blob.id)
        end
      end

      context "ログインユーザーがいいねを登録しているとき" do
        let!(:image_like) { create(:image_like, user: user, image: image, blob_id: image_blob.id) }
        let!(:former_like_count) { ImageLike.where(blob_id: image_blob.id).count }

        before do
          sign_in user
          visit spot_images_path(spot)
          find("#image_blob_#{image_blob.id}").click
        end

        it "いいねの登録を削除できる" do
          expect do
            find(".remove-like-image-btn").click
            expect(page).to have_selector(".add-like-image-btn")
            expect(find(".image-like-btn-wrap")).to have_content(former_like_count - 1)
          end.to change { ImageLike.count }.by(-1)
        end
      end

      context "ログインユーザーが投稿した画像のとき" do
        let!(:image_poster) { User.find(image.user_id) }

        before do
          sign_in image_poster
          visit spot_images_path(spot)
          find("#image_blob_#{image_blob.id}").click
        end

        it "登録のリンクが表示されない" do
          expect(find(".image-like-btn-wrap")).not_to have_selector("a")
        end
      end
    end

    context "ログインしていないとき" do
      before do
        visit spot_images_path(spot)
        find("#image_blob_#{image_blob.id}").click
      end

      it "ログインページへのリンクが表示される" do
        expect(find(".image-like-btn-wrap")).to have_link(href: new_user_session_path)
      end
    end
  end
end
