require 'rails_helper'

RSpec.describe ReviewHelper, type: :helper do
  describe "#form_image_saved?" do
    subject { helper.form_image_saved?(resource) }

    let!(:resource) { ReviewPosterForm.new(review: review) }

    context "引数に渡したインスタンスのReviewレコードに関連するImageレコードが存在する、かつDBに保存されているとき" do
      let!(:review) { create(:review, :with_image) }

      it "trueを返す" do
        expect(subject).to eq(true)
      end
    end

    context "引数に渡したインスタンスのReviewレコードに関連するImageレコードが存在しない" do
      let!(:review) { create(:review) }

      it "falseを返す" do
        expect(subject).to eq(false)
      end
    end

    context "引数に渡したインスタンスのReviewレコードに関連するImageレコードがDBに保存されていないとき" do
      let!(:review) { create(:review) }
      let(:image) { attributes_for(:image) }

      before { review.build_image(image) }

      it "falseを返す" do
        expect(subject).to eq(false)
      end
    end
  end
end
