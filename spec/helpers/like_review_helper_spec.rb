require 'rails_helper'

RSpec.describe LikeReviewHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:review) { create(:review, user_id: user.id) }

  describe "#review_posted_by_another?" do
    context "引数に渡したReviewレコードのuser_idと、ログインユーザーのidが異なるとき" do
      before { allow(helper).to receive(:current_user).and_return(another_user) }

      it "trueを返す" do
        expect(helper.review_posted_by_another?(review)).to eq(true)
      end
    end

    context "引数に渡したReviewレコードのuser_idと、ログインユーザーのidが同じとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it "falseを返す" do
        expect(helper.review_posted_by_another?(review)).to eq(false)
      end
    end
  end

  describe "#review_liked?" do
    context "ログインユーザーが存在するとき" do
      before { allow(helper).to receive(:current_user).and_return(another_user) }

      context "引数に渡したReviewレコードのidを持つLikeReviewレコードが存在するとき" do
        let!(:like_review) { create(:like_review, user_id: another_user.id, review_id: review.id) }

        it "trueを返す" do
          expect(helper.review_liked?(review)).to eq(true)
        end
      end

      context "引数に渡したReviewレコードのidを持つLikeReviewレコードが存在しないとき" do
        it "falseを返す" do
          expect(helper.review_liked?(review)).to eq(false)
        end
      end
    end

    context "ログインユーザーが存在しないとき" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "falseを返す" do
        expect(helper.review_liked?(review)).to eq(false)
      end
    end
  end
end
