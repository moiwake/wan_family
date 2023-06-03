require 'rails_helper'

RSpec.describe "LikeImagesSystemSpecs", type: :system, js: true do
  let!(:spot) { create(:spot) }
  let!(:user) { create(:user) }
  let!(:image_poster) { create(:user) }
  let!(:image) { create(:image, :attached, spot: spot, user: image_poster, review: create(:review, spot: spot, user: image_poster)) }
  let(:image_blob) { image.files_blobs[0] }
  let!(:image_likes) { create_list(:image_like, 3, image: image, blob_id: image_blob.id) }
  let!(:current_like_count) { ImageLike.where(blob_id: image_blob.id).count }

  describe "画像のいいね登録" do
    shared_examples "いいねの総計の表示" do
      before { visit send(path, target_spot) }

      it "画像に登録されているいいねの総計を表示する" do
        find("#image_blob_#{image_blob.id}").click
        expect(find(".image-like-btn-wrap")).to have_content(current_like_count)
      end
    end

    shared_examples "ユーザー自身が投稿したの画像へのいいね登録" do
      before do
        sign_in image_poster
        visit send(path, target_spot)
        find("#image_blob_#{image_blob.id}").click
      end

      it "登録のリンクが表示されない" do
        expect(find(".image-like-btn-wrap")).not_to have_selector("a")
      end
    end

    shared_examples "ログインしているときのいいね登録" do
      context "ログインユーザーがいいねを登録していないとき" do
        let!(:former_like_count) { ImageLike.where(blob_id: image_blob.id).count }
        let(:new_like) { ImageLike.last }

        before do
          sign_in user
          visit send(path, target_spot)
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
          visit send(path, target_spot)
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
        include_examples "ユーザー自身が投稿したの画像へのいいね登録"
      end
    end

    shared_examples "ログインしていないときのいいね登録" do
      before do
        visit send(path, target_spot)
        find("#image_blob_#{image_blob.id}").click
      end

      it "ログインページへのリンクが表示される" do
        expect(find(".image-like-btn-wrap")).to have_link(href: new_user_session_path)
      end
    end

    context "トップページで実行するとき" do
      let(:path) { "root_path" }
      let(:target_spot) { nil }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ログインしているときのいいね登録"
      it_behaves_like "ログインしていないときのいいね登録"
    end

    context "スポット詳細ページで実行するとき" do
      let(:path) { "spot_path" }
      let(:target_spot) { spot }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ログインしているときのいいね登録"
      it_behaves_like "ログインしていないときのいいね登録"
    end

    context "スポットの画像一覧ページで実行するとき" do
      let(:path) { "spot_images_path" }
      let(:target_spot) { spot }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ログインしているときのいいね登録"
      it_behaves_like "ログインしていないときのいいね登録"
    end

    context "スポットのレビュー一覧ページで実行するとき" do
      let(:path) { "spot_reviews_path" }
      let(:target_spot) { spot }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ログインしているときのいいね登録"
      it_behaves_like "ログインしていないときのいいね登録"
    end

    context "ユーザーの投稿画像一覧ページで実行するとき" do
      let(:path) { "users_mypage_image_index_path" }
      let(:target_spot) { nil }

      before { sign_in image_poster }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ユーザー自身が投稿したの画像へのいいね登録"
    end

    context "ユーザーの投稿レビュー一覧ページで実行するとき" do
      let(:path) { "users_mypage_review_index_path" }
      let(:target_spot) { nil }

      before { sign_in image_poster }

      it_behaves_like "いいねの総計の表示"
      it_behaves_like "ユーザー自身が投稿したの画像へのいいね登録"
    end
  end
end
