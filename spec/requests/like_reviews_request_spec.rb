require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "LikeReviews", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review) }

  before { sign_in user }

  describe "POST /create" do
    let(:new_like_review) { LikeReview.last }

    subject { post spot_review_like_reviews_path(spot, review), xhr: true }

    it "画像にいいねを登録できる" do
      expect { subject }.to change { LikeReview.count }.by(1)
      expect(new_like_review.user_id).to eq(user.id)
      expect(new_like_review.review_id).to eq(review.id)
    end

    it_behaves_like "returns http success"
  end

  describe "DELETE /destroy" do
    let!(:like_review) { create(:like_review, user_id: user.id, review_id: review.id) }

    subject { delete spot_review_like_review_path(spot, review, like_review), xhr: true }

    it "画像のいいねを削除できる" do
      expect { subject }.to change { LikeReview.count }.by(-1)
    end

    it_behaves_like "returns http success"
  end
end
