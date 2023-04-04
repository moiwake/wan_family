require 'rails_helper'

RSpec.describe "ReviewHelpfulnessesSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review, spot_id: spot.id) }
  let!(:review_helpfulnesses) { create_list(:review_helpfulness, 3, review_id: review.id) }
  let!(:current_like_count) { ReviewHelpfulness.where(review_id: review.id).count }

  describe "レビューのGood登録" do
    before { visit spot_review_path(spot, review) }

    it "レビューに登録されているGoodの総計を表示する" do
      expect(find("#post-review-helpfulness")).to have_content(current_like_count)
    end

    context "ログインしているとき" do
      before { sign_in user }

      context "ログインユーザーがレビューにGoodを登録していないとき" do
        let!(:before_like_count) { ReviewHelpfulness.where(review_id: review.id).count }
        let(:new_like) { ReviewHelpfulness.last }

        before { visit spot_review_path(spot, review) }

        it "レビューにGoodの登録ができる" do
          expect do
            find("#add-review-helpfulness").click
            expect(find("#post-review-helpfulness")).to have_content(before_like_count + 1)
          end.to change { ReviewHelpfulness.count }.by(1)

          expect(new_like.user_id).to eq(user.id)
          expect(new_like.review_id).to eq(review.id)
        end
      end

      context "ログインユーザーがレビューにGoodを登録しているとき" do
        let!(:review_helpfulness) { create(:review_helpfulness, user_id: user.id, review_id: review.id) }
        let!(:before_like_count) { ReviewHelpfulness.where(review_id: review.id).count }

        before { visit spot_review_path(spot, review) }

        it "レビューのGoodの登録を削除できる" do
          expect do
            find("#remove-review-helpfulness").click
            expect(find("#post-review-helpfulness")).to have_content(before_like_count - 1)
          end.to change { ReviewHelpfulness.count }.by(-1)
        end
      end

      context "ログインユーザーが投稿したレビューのとき" do
        let(:review_poster) { User.find(review.user_id) }

        before do
          sign_in review_poster
          visit spot_review_path(spot, review)
        end

        it "Good登録のリンクが表示されない" do
          expect(find("#post-review-helpfulness")).not_to have_selector("a")
        end
      end
    end

    context "ログインしていないとき" do
      it "ログインページへのリンクが表示される" do
        expect(find("#post-review-helpfulness")).to have_link(href: new_user_session_path)
      end
    end
  end
end
