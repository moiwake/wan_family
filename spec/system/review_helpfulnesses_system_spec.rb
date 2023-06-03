require 'rails_helper'

RSpec.describe "ReviewHelpfulnessesSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:review) { create(:review, spot: spot) }
  let!(:review_helpfulnesses) { create_list(:review_helpfulness, 3, review: review) }
  let!(:current_like_count) { review.review_helpfulnesses.count }
  let(:review_poster) { User.find(review.user_id) }

  describe "レビューの「役立った」の登録" do
    shared_examples "「役立った」の総計の表示" do
      before { visit send(path, target_spot) }

      it "レビューに登録されている「役立った」の総計を表示する" do
        expect(page.all(".review-helpfulness-btn-wrap")[0]).to have_content(current_like_count)
      end
    end

    shared_examples "ユーザー自身が投稿したのレビューへの「役立った」の登録" do
      before do
        sign_in review_poster
        visit send(path, target_spot)
      end

      it "「役立った」を登録するリンクが表示されない" do
        expect(find(".review-helpfulness-btn-wrap")).to have_link(href: "")
      end
    end

    shared_examples "ログインしているときの「役立った」の登録" do
      before { sign_in user }

      context "ログインユーザーがレビューに「役立った」を登録していないとき" do
        let!(:before_like_count) { ReviewHelpfulness.where(review_id: review.id).count }
        let(:new_like) { ReviewHelpfulness.last }

        before { visit send(path, target_spot) }

        it "レビューに「役立った」の登録ができる" do
          expect do
            find(".review-helpfulness-add-btn").click
            expect(all(".review-helpfulness-btn-wrap")[0]).to have_content(before_like_count + 1)
          end.to change { ReviewHelpfulness.count }.by(1)

          expect(new_like.user_id).to eq(user.id)
          expect(new_like.review_id).to eq(review.id)
        end
      end

      context "ログインユーザーがレビューに「役立った」を登録しているとき" do
        let!(:review_helpfulness) { create(:review_helpfulness, user: user, review: review) }
        let!(:before_like_count) { ReviewHelpfulness.where(review_id: review.id).count }

        before { visit send(path, target_spot) }

        it "レビューの「役立った」の登録を削除できる" do
          expect do
            find(".review-helpfulness-remove-btn").click
            expect(all(".review-helpfulness-btn-wrap")[0]).to have_content(before_like_count - 1)
          end.to change { ReviewHelpfulness.count }.by(-1)
        end
      end

      context "ログインユーザーが投稿したレビューのとき" do
        include_examples "ユーザー自身が投稿したのレビューへの「役立った」の登録"
      end
    end

    shared_examples "ログインしていないときの「役立った」の登録" do
      before { visit send(path, target_spot) }

      it "ログインページへのリンクが表示される" do
        expect(find(".review-helpfulness-btn-wrap")).to have_link(href: new_user_session_path)
      end
    end

    context "スポット詳細ページで実行するとき" do
      let(:path) { "spot_path" }
      let(:target_spot) { spot }

      it_behaves_like "「役立った」の総計の表示"
      it_behaves_like "ログインしているときの「役立った」の登録"
      it_behaves_like "ログインしていないときの「役立った」の登録"
    end

    context "スポットのレビュー一覧ページで実行するとき" do
      let(:path) { "spot_reviews_path" }
      let(:target_spot) { spot }

      it_behaves_like "「役立った」の総計の表示"
      it_behaves_like "ログインしているときの「役立った」の登録"
      it_behaves_like "ログインしていないときの「役立った」の登録"
    end

    context "ユーザーの投稿レビュー一覧ページで実行するとき" do
      let(:path) { "users_mypage_review_index_path" }
      let(:target_spot) { nil }

      before { sign_in review_poster }

      it_behaves_like "「役立った」の総計の表示"
      it_behaves_like "ユーザー自身が投稿したのレビューへの「役立った」の登録"
    end
  end
end
