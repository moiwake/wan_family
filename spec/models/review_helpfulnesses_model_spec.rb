require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe ReviewHelpfulness, type: :model do
  let!(:review_helpfulness) { create(:review_helpfulness) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { review_helpfulness }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:review_helpfulness, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "user_idカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "review_idカラム" do
      let(:attribute) { :review }

      context "nilのとき" do
        let(:type) { :nil }

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
end