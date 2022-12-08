require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review) }
  let!(:image) { create(:image, :attached, review_id: review.id) }

  describe "GET /index" do
    before do
      get spot_reviews_path(spot.id)
    end

    it_behaves_like "returns http success"
  end

  describe "GET /new" do
    context "ログインしているとき" do
      before do
        sign_in user
        get new_spot_review_path(spot.id)
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before do
        get new_spot_review_path(spot.id)
      end

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /show" do
    before do
      get spot_review_path(spot.id, review.id)
    end

    it_behaves_like "returns http success"
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get edit_spot_review_path(spot.id, review.id)
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before do
        get edit_spot_review_path(spot.id, review.id)
      end

      it_behaves_like "redirects to login page"
    end
  end

  describe "POST /create" do
    let(:params) { { review_attributes: review_params, image_attributes: image_params } }
    let(:review_params) { FactoryBot.attributes_for(:review, user_id: user.id, spot_id: spot.id) }
    let(:image_params) do
      FactoryBot.attributes_for(:image, files: [
        fixture_file_upload(new_file_paths[0], 'image/png'),
        fixture_file_upload(new_file_paths[1], 'image/png'),
      ])
    end
    let(:new_file_paths) { [Rails.root.join('spec', 'fixtures', 'images', 'test1.png'), Rails.root.join('spec', 'fixtures', 'images', 'test2.png')] }
    let(:new_filenames) { new_file_paths.map { |new_file_path| new_file_path.split.last.to_s } }

    before do
      sign_in user
    end

    context "送信されたパラメータが妥当なとき" do
      subject { post spot_reviews_path(spot.id), params: { review_poster_form: params } }

      it "新しいレビューのレコードを保存できる" do
        expect { subject }.to change { Review.count }.by(1)
        expect(Review.last.title).to eq(review_params[:title])
        expect(Review.last.comment).to eq(review_params[:comment])
        expect(Review.last.dog_score).to eq(review_params[:dog_score])
        expect(Review.last.human_score).to eq(review_params[:human_score])
      end

      it "新しいイメージのレコードを保存できる" do
        expect { subject }.to change { Image.count }.by(1)
      end

      it "イメージのレコードに複数のファイルデータを保存できる" do
        subject
        new_filenames.each do |new_filename|
          expect(image.reload.files.blobs.pluck(:filename).include?(new_filename)).to eq(true)
        end
      end

      it "保存の後、投稿したレビューの詳細ページにリダイレクトする" do
        subject
        expect(response).to redirect_to(spot_review_path(spot.id, Review.last.id))
      end

      it_behaves_like "returns 302 HTTP Status Code"
    end

    context "送信されたレビューのパラメータが不正なとき" do
      let(:params) { { review_attributes: invalid_review_params, image_attributes: image_params } }
      let(:invalid_review_params) { FactoryBot.attributes_for(:review, :invalid) }

      subject { post spot_reviews_path(spot.id), params: { review_poster_form: params } }

      it "レビューのレコードを保存できない" do
        expect { subject }.to change { Review.count }.by(0)
      end

      it "イメージのレコードを保存できない" do
        expect { subject }.to change { Image.count }.by(0)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Review.human_attribute_name(:title)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:comment)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:dog_score)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:human_score)}を入力してください")
      end

      it_behaves_like "returns http success"
    end

    context "送信されたイメージのパラメータが不正なとき" do
      let(:params) { { review_attributes: review_params, image_attributes: invalid_image_params } }
      let(:invalid_image_params) do
        FactoryBot.attributes_for(:image, files: [
          fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.txt'), 'text/txt'),
        ])
      end

      subject { post spot_reviews_path(spot.id), params: { review_poster_form: params } }

      it "レビューのレコードを保存できない" do
        expect { subject }.to change { Review.count }.by(0)
      end

      it "イメージのレコードを保存できない" do
        expect { subject }.to change { Image.count }.by(0)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Image.human_attribute_name(:files)}のファイル形式が不正です。")
      end

      it_behaves_like "returns http success"
    end
  end

  describe "PATCH /update" do
    let(:updated_params) { { review_attributes: updated_review_params, image_attributes: updated_image_params } }
    let(:updated_review_params) { FactoryBot.attributes_for(:review, user_id: review.user.id, spot_id: review.spot.id) }
    let(:updated_image_params) do
      FactoryBot.attributes_for(:image,
        files: [fixture_file_upload(added_file_path, 'image/png'), saved_files].flatten,
        files_blob_ids: [deleted_image_file_id.to_s]
      )
    end
    let(:saved_files) { image.files.map { |file| file.signed_id } }
    let(:saved_filenames) { image.files.blobs.map { |blob| blob.filename.to_s } }
    let(:added_file_path) { Rails.root.join('spec', 'fixtures', 'images', 'test3.png') }
    let(:added_filename) { added_file_path.split.last.to_s }
    let(:deleted_image_file_id) { image.files.first.id }

    before do
      sign_in user
    end

    context "送信されたパラメータが妥当なとき" do
      subject { patch spot_review_path(review.spot.id, review.id), params: { review_poster_form: updated_params } }

      it "レビューのレコードを更新できる" do
        expect { subject }.to change { Review.count }.by(0)
        expect(review.reload.title).to eq(updated_review_params[:title])
        expect(review.reload.comment).to eq(updated_review_params[:comment])
        expect(review.reload.dog_score).to eq(updated_review_params[:dog_score])
        expect(review.reload.human_score).to eq(updated_review_params[:human_score])
      end

      it "イメージのレコードにファイルデータを追加できる" do
        subject

        saved_filenames.each do |saved_filename|
          expect(image.reload.files.blobs.pluck(:filename).include?(saved_filename)).to eq(true)
        end

        expect(image.reload.files.blobs.pluck(:filename).include?(added_filename)).to eq(true)
      end

      it "イメージのレコードから指定したファイルデータを削除できる" do
        subject
        expect(image.reload.files.pluck(:id).include?(deleted_image_file_id)).to eq(false)
      end

      it "更新の後、更新したレビューの詳細ページにリダイレクトする" do
        subject
        expect(response).to redirect_to(spot_review_path(review.spot.id, Review.last.id))
      end

      it_behaves_like "returns 302 HTTP Status Code"
    end

    context "送信されたレビューのパラメータが不正なとき" do
      let(:updated_params) { { review_attributes: invalid_review_params, image_attributes: updated_image_params } }
      let(:invalid_review_params) { FactoryBot.attributes_for(:review, :invalid) }

      subject { patch spot_review_path(review.spot.id, review.id), params: { review_poster_form: updated_params } }

      it "レビューのレコードを更新できない" do
        review.reload
        subject
        expect(review.saved_change_to_title?).to eq(false)
        expect(review.saved_change_to_comment?).to eq(false)
        expect(review.saved_change_to_dog_score?).to eq(false)
        expect(review.saved_change_to_human_score?).to eq(false)
      end

      it "イメージのレコードにファイルデータを追加できない" do
        subject
        expect(image.reload.files.blobs.pluck(:filename).include?(added_filename)).to eq(false)
      end

      it "イメージのレコードのファイルデータを削除できない" do
        subject
        expect(image.reload.files.pluck(:id).include?(deleted_image_file_id)).to eq(true)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Review.human_attribute_name(:title)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:comment)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:dog_score)}を入力してください")
        expect(response.body).to include("#{Review.human_attribute_name(:human_score)}を入力してください")
      end

      it_behaves_like "returns http success"
    end

    context "送信されたイメージのパラメータが不正なとき" do
      let(:updated_params) { { review_attributes: updated_review_params, image_attributes: invalid_image_params } }
      let(:invalid_image_params) do
        FactoryBot.attributes_for(:image,
          files: [fixture_file_upload(added_file_path, 'text/txt'), saved_files].flatten,
          files_blob_ids: [deleted_image_file_id.to_s],
        )
      end
      let(:added_file_path) { Rails.root.join('spec', 'fixtures', 'test.txt') }

      subject { patch spot_review_path(review.spot.id, review.id), params: { review_poster_form: updated_params } }

      it "レビューのレコードを更新できない" do
        review.reload
        subject
        expect(review.saved_change_to_title?).to eq(false)
        expect(review.saved_change_to_comment?).to eq(false)
        expect(review.saved_change_to_dog_score?).to eq(false)
        expect(review.saved_change_to_human_score?).to eq(false)
      end

      it "イメージのレコードにファイルデータを追加できない" do
        subject
        expect(image.reload.files.blobs.pluck(:filename).include?(added_filename)).to eq(false)
      end

      it "イメージのレコードから指定したファイルデータを削除できない" do
        subject
        expect(image.reload.files.pluck(:id).include?(deleted_image_file_id)).to eq(true)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Image.human_attribute_name(:files)}のファイル形式が不正です。")
      end

      it_behaves_like "returns http success"
    end
  end

  describe "DELETE /destroy" do
    subject { delete spot_review_path(review.spot.id, review.id) }

    before do
      sign_in user
    end

    it "レビューのレコードを削除できる" do
      expect { subject }.to change { Review.count }.by(-1)
    end

    it "イメージのレコードを削除できる" do
      expect { subject }.to change { Image.count }.by(-1)
    end

    it "削除の後、ユーザーの投稿レビュー一覧ページにリダイレクトする" do
      subject
      expect(response).to redirect_to(users_review_index_path)
    end

    it_behaves_like "returns 302 HTTP Status Code"
  end
end

