require 'rails_helper'

RSpec.describe ReviewHelpfulnessHelper, type: :helper do
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

  describe "#review_helpful?" do
    context "ログインユーザーが存在するとき" do
      before { allow(helper).to receive(:current_user).and_return(another_user) }

      context "引数に渡したReviewレコードのidを持つReviewHelpfulnessレコードが存在するとき" do
        let!(:review_helpfulness) { create(:review_helpfulness, user_id: another_user.id, review_id: review.id) }

        it "trueを返す" do
          expect(helper.review_helpful?(review)).to eq(true)
        end
      end

      context "引数に渡したReviewレコードのidを持つReviewHelpfulnessレコードが存在しないとき" do
        it "falseを返す" do
          expect(helper.review_helpful?(review)).to eq(false)
        end
      end
    end

    context "ログインユーザーが存在しないとき" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "falseを返す" do
        expect(helper.review_helpful?(review)).to eq(false)
      end
    end
  end
end
