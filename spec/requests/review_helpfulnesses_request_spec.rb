require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "ReviewHelpfulnesses", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review) }

  before { sign_in user }

  describe "POST /create" do
    subject { post spot_review_review_helpfulnesses_path(spot, review), xhr: true }

    let(:new_review_helpfulness) { ReviewHelpfulness.last }

    it "レビューに役立ったを登録できる" do
      expect { subject }.to change { ReviewHelpfulness.count }.by(1)
      expect(new_review_helpfulness.user_id).to eq(user.id)
      expect(new_review_helpfulness.review_id).to eq(review.id)
    end

    it_behaves_like "HTTPリクエストの成功"
  end

  describe "DELETE /destroy" do
    subject { delete spot_review_review_helpfulness_path(spot, review, review_helpfulness), xhr: true }

    let!(:review_helpfulness) { create(:review_helpfulness, user: user, review: review) }

    it "レビューの役立ったを削除できる" do
      expect { subject }.to change { ReviewHelpfulness.count }.by(-1)
    end

    it_behaves_like "HTTPリクエストの成功"
  end
end
