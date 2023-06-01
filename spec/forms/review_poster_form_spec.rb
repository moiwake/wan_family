require 'rails_helper'

RSpec.describe ReviewPosterForm, type: :model do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe "#review_attributes=" do
    let(:review_attributes) { attributes_for(:review, user_id: user.id, spot_id: spot.id) }
    let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: { "review_attributes" => review_attributes }) }
    let(:review) { review_poster_form_instance.review }

    it "Reviewレコードの属性値に、パラメータの値を設定する" do
      expect(review.title).to eq(review_attributes[:title])
      expect(review.comment).to eq(review_attributes[:comment])
      expect(review.dog_score).to eq(review_attributes[:dog_score])
      expect(review.human_score).to eq(review_attributes[:human_score])
      expect(review.visit_date.to_s).to eq(review_attributes[:visit_date])
      expect(review.user_id).to eq(review_attributes[:user_id])
      expect(review.spot_id).to eq(review_attributes[:spot_id])
    end
  end

  describe "#image_attributes=" do
    let(:image_attributes) { attributes_for(:image, files: files) }
    let(:files) { filenames.map { |filename| fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', filename), 'image/png') } }
    let(:image) { review_poster_form_instance.review.image }

    context "Reviewレコードが未保存のとき" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: { "image_attributes" => image_attributes }, review: review) }
      let(:review) { build(:review, user: user, spot: spot) }
      let(:filenames) { ["test1.png", "test2.png"] }

      it "Imageレコードを作成し、属性値にパラメータと指定の値を設定する" do
        filenames.each_with_index do |filename, i|
          expect(image.files.blobs[i].filename).to eq(filename)
        end

        expect(image.user_id).to eq(review.user_id)
        expect(image.spot_id).to eq(review.spot_id)
      end
    end

    context "Reviewレコードに関連するImageレコードがnilのとき" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: { "image_attributes" => image_attributes }, review: review) }
      let!(:review) { create(:review, user: user, spot: spot) }
      let(:filenames) { ["test1.png", "test2.png"] }

      it "Imageレコードを作成し、属性値にパラメータと指定の値を設定する" do
        filenames.each_with_index do |filename, i|
          expect(image.files.blobs[i].filename).to eq(filename)
        end

        expect(image.user_id).to eq(review.user_id)
        expect(image.spot_id).to eq(review.spot_id)
        expect(image.review_id).to eq(review.id)
      end
    end

    context "Reviewレコードが保存済み、かつReviewレコードに関連するImageレコードが存在するとき" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: { "image_attributes" => image_attributes }, review: review) }
      let!(:review) { create(:review, user: user, spot: spot) }
      let(:filenames) { ["test3.png"] }

      it "Imageレコードの属性値に、パラメータの値を設定する" do
        expect(image.files.blobs[0].filename).to eq(filenames[0])
      end
    end
  end
end
