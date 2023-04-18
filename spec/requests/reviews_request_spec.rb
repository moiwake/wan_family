require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Reviews", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review) }
  let!(:image) { create(:image, :attached, review: review) }

  describe "GET /index" do
    before { get spot_reviews_path(spot) }

    it_behaves_like "returns http success"
  end

  describe "GET /new" do
    context "ログインしているとき" do
      before do
        sign_in user
        get new_spot_review_path(spot)
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get new_spot_review_path(spot) }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get edit_spot_review_path(spot, review)
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get edit_spot_review_path(spot, review) }

      it_behaves_like "redirects to login page"
    end
  end

  describe "POST /create" do
    let(:params) { { review_attributes: review_params, image_attributes: image_params } }
    let(:review_params) { attributes_for(:review, user_id: user.id, spot_id: spot.id) }
    let(:image_params) { attributes_for(:image, files: files) }
    let(:files) { filenames.map { |filename| fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', filename), 'image/png') } }
    let(:filenames) { ["test1.png", "test2.png"] }

    before { sign_in user }

    context "送信されたパラメータが妥当なとき" do
      subject { post spot_reviews_path(spot), params: { review_poster_form: params } }

      it "新しいReviewレコードを保存できる" do
        expect { subject }.to change { Review.count }.by(1)
        expect(Review.last.title).to eq(review_params[:title])
        expect(Review.last.comment).to eq(review_params[:comment])
        expect(Review.last.dog_score).to eq(review_params[:dog_score])
        expect(Review.last.human_score).to eq(review_params[:human_score])
        expect(Review.last.visit_date.to_s).to eq(review_params[:visit_date])
      end

      it "新しいImageレコードを保存できる" do
        expect { subject }.to change { Image.count }.by(1)
      end

      it "Imageレコードに関連する複数のBlobレコードを保存できる" do
        subject
        filenames.each_with_index do |filename, i|
          expect(Image.last.files_blobs[i].filename).to eq(filename)
        end
      end

      it "保存後、レビュー一覧ページにリダイレクトする" do
        subject
        expect(response).to redirect_to(spot_reviews_path(spot))
      end

      it_behaves_like "returns 302 http status code"
    end

    context "送信されたレビューのパラメータが不正なとき" do
      let(:params) { { review_attributes: attributes_for(:review, :invalid) } }

      subject { post spot_reviews_path(spot.id), params: { review_poster_form: params } }

      it "Reviewレコードを保存できない" do
        expect { subject }.to change { Review.count }.by(0)
      end

      it "Imageレコードを保存できない" do
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
      let(:params) { { image_attributes: attributes_for(:image, files: nil) } }

      subject { post spot_reviews_path(spot), params: { review_poster_form: params } }

      it "Reviewレコードを保存できない" do
        expect { subject }.to change { Review.count }.by(0)
      end

      it "Imageレコードを保存できない" do
        expect { subject }.to change { Image.count }.by(0)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Image.human_attribute_name(:files)}を入力してください")
      end

      it_behaves_like "returns http success"
    end
  end

  describe "PATCH /update" do
    let(:params) { { review_attributes: updated_review_params, image_attributes: updated_image_params } }
    let(:updated_review_params) { attributes_for(:review, user_id: review.user.id, spot_id: review.spot.id) }
    let(:updated_image_params) { attributes_for(:image, files: added_file, file_ids: [removed_file_id.to_s]) }
    let(:added_file) { [fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', added_filename), 'image/png')] }
    let(:added_filename) { "test3.png" }
    let(:removed_file_id) { image.files[0].id }

    before { sign_in user }

    context "送信されたパラメータが妥当なとき" do
      subject { patch spot_review_path(review.spot, review), params: { review_poster_form: params } }

      it "Reviewレコードを更新できる" do
        expect { subject }.to change { Review.count }.by(0)
        expect(review.reload.title).to eq(updated_review_params[:title])
        expect(review.reload.comment).to eq(updated_review_params[:comment])
        expect(review.reload.dog_score).to eq(updated_review_params[:dog_score])
        expect(review.reload.human_score).to eq(updated_review_params[:human_score])
        expect(review.reload.visit_date.to_s).to eq(updated_review_params[:visit_date])
      end

      it "Imageレコードに関連するBlobレコードを追加できる" do
        subject
        expect(image.reload.files_blobs.pluck(:filename).include?(added_filename)).to eq(true)
      end

      it "Imageレコードに関連するBlobレコードを削除できる" do
        subject
        expect(image.reload.files.ids.include?(removed_file_id)).to eq(false)
      end

      it "更新後、ユーザーの投稿レビュー一覧ページにリダイレクトする" do
        subject
        expect(response).to redirect_to(users_mypage_review_index_path)
      end

      it_behaves_like "returns 302 http status code"
    end

    context "送信されたレビューのパラメータが不正なとき" do
      let(:updated_params) { { review_attributes: attributes_for(:review, :invalid), image_attributes: updated_image_params } }

      subject { patch spot_review_path(review.spot, review), params: { review_poster_form: updated_params } }

      it "Reviewレコードを更新できない" do
        review.reload
        subject
        expect(review.saved_change_to_title?).to eq(false)
        expect(review.saved_change_to_comment?).to eq(false)
        expect(review.saved_change_to_dog_score?).to eq(false)
        expect(review.saved_change_to_human_score?).to eq(false)
      end

      it "Imageレコードに関連するBlobレコードを追加できない" do
        subject
        expect(image.reload.files.blobs.pluck(:filename).include?(added_filename)).to eq(false)
      end

      it "Imageレコードに関連するBlobレコードを削除できない" do
        subject
        expect(image.reload.files.pluck(:id).include?(removed_file_id)).to eq(true)
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
      let(:added_file) { [fixture_file_upload(Rails.root.join('spec', 'fixtures', added_invalid_filename), 'text/txt')] }
      let(:added_invalid_filename) { 'test.txt' }

      subject { patch spot_review_path(review.spot, review), params: { review_poster_form: params } }

      it "Reviewレコードを更新できない" do
        review.reload
        subject
        expect(review.saved_change_to_title?).to eq(false)
        expect(review.saved_change_to_comment?).to eq(false)
        expect(review.saved_change_to_dog_score?).to eq(false)
        expect(review.saved_change_to_human_score?).to eq(false)
      end

      it "Imageレコードに関連するBlobレコードを追加できない" do
        subject
        expect(image.reload.files.blobs.pluck(:filename).include?(added_invalid_filename)).to eq(false)
      end

      it "バリデーションエラーが表示される" do
        subject
        expect(response.body).to include("#{Image.human_attribute_name(:files)}のファイル形式が不正です。")
      end

      it_behaves_like "returns http success"
    end
  end

  describe "DELETE /destroy" do
    subject { delete spot_review_path(review.spot, review) }

    before { sign_in user }

    it "Reviewレコードを削除できる" do
      expect { subject }.to change { Review.count }.by(-1)
    end

    it "Imageレコードを削除できる" do
      expect { subject }.to change { Image.count }.by(-1)
    end

    it "削除後、ユーザーの投稿レビュー一覧ページにリダイレクトする" do
      subject
      expect(response).to redirect_to(users_mypage_review_index_path)
    end

    it_behaves_like "returns 302 http status code"
  end
end

