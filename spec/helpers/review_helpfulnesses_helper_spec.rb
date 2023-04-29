require 'rails_helper'

RSpec.describe ReviewHelpfulnessHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:review) { create(:review, user: user) }

  describe "#review_posted_by_another?" do
    context "引数に渡したReviewレコードのuser_idカラムと、ログインユーザーのidが異なるとき" do
      let!(:another_user) { create(:user) }

      before { allow(helper).to receive(:current_user).and_return(another_user) }

      it "trueを返す" do
        expect(helper.review_posted_by_another?(review)).to eq(true)
      end
    end

    context "引数に渡したReviewレコードのuser_idカラムと、ログインユーザーのidが同じとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it "falseを返す" do
        expect(helper.review_posted_by_another?(review)).to eq(false)
      end
    end
  end

  describe "#review_helpful?" do
    let!(:review_helpfulness) { create(:review_helpfulness) }

    context "引数に渡したReviewHelpfulnessのレコードが存在するとき" do
      it "trueを返す" do
        expect(helper.review_helpful?(review_helpfulness)).to eq(true)
      end
    end

    context "引数がnilのとき" do
      it "falseを返す" do
        expect(helper.review_helpful?(nil)).to eq(false)
      end
    end

    context "引数に渡したReviewHelpfulnessのレコードがDBに保存されていないとき" do
      before { review_helpfulness.destroy }

      it "falseを返す" do
        expect(helper.review_helpful?(review_helpfulness)).to eq(false)
      end
    end
  end

  describe "#review_helpfulness_by_user" do
    let!(:review_helpfulness) { create(:review_helpfulness, user: user, review: review) }

    context "ログインユーザーが存在するとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it "引数に渡したReviewレコードのidと、ログインユーザーのidを外部キーに持つReviewHelpfulnessのレコードを返す" do
        expect(helper.review_helpfulness_by_user(review)).to eq(review_helpfulness)
      end
    end

    context "ログインユーザーが存在しないとき" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "nilを返す" do
        expect(helper.review_helpfulness_by_user(review)).to eq(nil)
      end
    end
  end

  describe "#review_helpfulness_btn_path" do
    let!(:spot) { create(:spot) }

    context "ログインユーザーが存在するとき" do
      before { allow(helper).to receive(:current_user).and_return(user) }

      context "引数のReviewレコードをログインユーザー以外が作成していたとき" do
        let!(:another_user) { create(:user) }
        let!(:review_by_another) { create(:review, user: another_user, spot: spot) }

        context "引数のReviewHelpnessレコードが存在して、かつDBに保存済みであるとき" do
          let(:review_helpfulness) { create(:review_helpfulness, user: user, review: review_by_another) }
          let(:expected_hash) { { href: spot_review_review_helpfulness_path(spot, review_by_another, review_helpfulness), method: :delete, class: "review-helpfulness-remove-btn", remote: true } }

          it "指定のハッシュを返す" do
            expect(helper.review_helpfulness_btn_path(review_by_another, review_helpfulness)).to eq(expected_hash)
          end
        end

        context "引数のReviewHelpnessレコードが存在しないとき" do
          let(:expected_hash) { { href: spot_review_review_helpfulnesses_path(spot, review_by_another), method: :post, class: "review-helpfulness-add-btn", remote: true } }

          it "指定のハッシュを返す" do
            expect(helper.review_helpfulness_btn_path(review_by_another, nil)).to eq(expected_hash)
          end
        end

        context "引数のReviewHelpnessレコードがDBされていないとき" do
          let(:review_helpfulness) { create(:review_helpfulness, user: user, review: review_by_another) }
          let(:expected_hash) { { href: spot_review_review_helpfulnesses_path(spot, review_by_another), method: :post, class: "review-helpfulness-add-btn", remote: true } }

          before { review_helpfulness.destroy }

          it "指定のハッシュを返す" do
            expect(helper.review_helpfulness_btn_path(review_by_another, review_helpfulness)).to eq(expected_hash)
          end
        end
      end

      context "引数のReviewレコードをログインユーザー以外が作成していたとき" do
        it "nilを返す" do
          expect(helper.review_helpfulness_btn_path(review, nil)).to eq(nil)
        end
      end
    end

    context "ログインユーザーが存在しないとき" do
      let(:expected_hash) { { href: new_user_session_path, class: "sign-in-btn" } }

      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "指定のハッシュを返す" do
        expect(helper.review_helpfulness_btn_path(nil, nil)).to eq(expected_hash)
      end
    end
  end
end
