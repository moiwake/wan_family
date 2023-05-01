require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe ReviewHelpfulness, type: :model do
  let!(:review_helpfulness) { create(:review_helpfulness) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { review_helpfulness }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:review_helpfulness, attribute => nil) }
    let(:message) { "を入力してください" }

    context "user_idカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end

    context "review_idカラム" do
      let(:attribute) { :review }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとreview_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:review_helpfulness, user_id: review_helpfulness.user_id, review_id: review_helpfulness.review_id) }

      it_behaves_like "adds validation error messages"
    end

    context "user_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:review_helpfulness, user_id: review_helpfulness.user_id) }

      it_behaves_like "the object is valid"
    end

    context "review_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:review_helpfulness, review_id: review_helpfulness.review_id) }

      it_behaves_like "the object is valid"
    end
  end

  describe "review_helpfulness_user_id_validatorのバリデーション" do
    let(:message) { "投稿者が自分のレビューに「役立った」を登録することはできません。" }

    context "レコードのreview_idを持つReviewレコードのuser_idと、レコードのuser_idが同じとき" do
      let!(:user) { create(:user) }
      let!(:review) { create(:review, user: user) }
      let!(:invalid_object) { build(:review_helpfulness, review: review, user: user) }
      let(:attribute) { :user }

      it_behaves_like "adds validation error messages"
    end
  end
end
