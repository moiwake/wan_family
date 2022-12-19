require 'rails_helper'

RSpec.describe ReviewPosterForm, type: :model do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  let(:params) { { review_attributes: review_params, image_attributes: image_params } }
  let(:review_params) { FactoryBot.attributes_for(:review, user_id: user.id, spot_id: spot.id) }
  let(:image_params) { FactoryBot.attributes_for(:image, files: new_files) }
  let(:new_files) do
    [
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test1.png'), 'image/png'),
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test2.png'), 'image/png'),
    ]
  end
  let(:new_filenames) { new_files.map { |new_file| new_file.original_filename } }

  let!(:saved_review) { create(:review, user_id: user.id, spot_id: spot.id) }
  let!(:saved_image) { create(:image, :attached, review_id: saved_review.id) }

  let(:updated_params) { { review_attributes: updated_review_params, image_attributes: updated_image_params } }
  let(:updated_review_params) { FactoryBot.attributes_for(:review, user_id: user.id, spot_id: spot.id) }
  let(:updated_image_params) { FactoryBot.attributes_for(:image, files: [added_file]) }
  let(:added_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test3.png'), 'image/png') }
  let(:added_filename) { added_file.original_filename }

  let(:invalid_params) { { review_attributes: invalid_review_params, image_attributes: invalid_image_params } }
  let(:invalid_review_params) { FactoryBot.attributes_for(:review, :invalid) }
  let(:invalid_image_params) { FactoryBot.attributes_for(:image, files: [invalid_file]) }
  let(:invalid_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.txt'), 'text/txt') }
  let(:invalid_filename) { invalid_file.original_filename }

  describe "#review_attributes=" do
    let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: params) }
    let(:review) { review_poster_form_instance.review }

    it "パラメータの値をレビューレコードの属性値に設定する" do
      expect(review.title).to eq(review_params[:title])
      expect(review.comment).to eq(review_params[:comment])
      expect(review.dog_score).to eq(review_params[:dog_score])
      expect(review.human_score).to eq(review_params[:human_score])
      expect(review.user_id).to eq(review_params[:user_id])
      expect(review.spot_id).to eq(review_params[:spot_id])
    end
  end

  describe "#image_attributes=" do
    context "review_poster_form_instanceのimageオブジェクトがnilのとき" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: params) }
      let(:review) { review_poster_form_instance.review }
      let(:image) { review_poster_form_instance.review.image }

      it "イメージレコードを作成し、パラメータの値と指定の外部キーを属性値に設定する" do
        new_filenames.each do |new_filename|
          expect(image.files.blobs.pluck(:filename).include?(new_filename)).to eq(true)
        end

        expect(image.user_id).to eq(review.user_id)
        expect(image.spot_id).to eq(review.spot_id)
        expect(image.review_id).to eq(review.id)
      end
    end

    context "review_poster_form_instanceのimageオブジェクトがnilではないとき" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: updated_params, review: saved_review, image: saved_image) }
      let(:image) { review_poster_form_instance.image }

      it "パラメータの値をイメージレコードの属性値に設定する" do
        expect(image.files.blobs.pluck(:filename).include?(added_filename)).to eq(true)
      end
    end
  end

  describe "#persist" do
    subject { review_poster_form_instance.send(:persist) }

    context "レビュー、イメージの属性値が妥当な場合" do
      context "新規登録" do
        let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: params) }

        it "レビューレコードが保存される" do
          expect { subject }.to change { Review.count }.by(1)
        end

        it "イメージレコードが保存される" do
          expect { subject }.to change { Image.count }.by(1)
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end

      context "更新" do
        let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: updated_params, review: saved_review, image: saved_image) }

        it "レビューレコードが更新される" do
          saved_review.reload
          expect { subject }.to change { Review.count }.by(0)
          expect(saved_review.saved_changes?).to eq(true)
        end

        it "イメージレコードにファイルデータが追加される" do
          expect do
            expect { subject }.to change { saved_image.files.blobs.length }.by(1)
          end.to change { Image.count }.by(0)
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end
    end

    context "レビュー、イメージの属性値が不正な場合" do
      context "新規登録" do
        let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: invalid_params) }

        it "レビューのレコードは保存されない" do
          expect { subject }.to change { Review.count }.by(0)
        end

        it "イメージのレコードは保存されない" do
          expect { subject }.to change { Image.count }.by(0)
        end

        it "falseを返す" do
          expect(subject).to eq(false)
        end
      end

      context "更新" do
        let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: invalid_params, review: saved_review, image: saved_image) }

        it "レビューのレコードは更新されない" do
          saved_review.reload
          subject
          expect(saved_review.saved_changes?).to eq(false)
        end

        it "イメージのレコードは追加されない" do
          expect { subject }.to change { saved_image.reload.files.blobs.length }.by(0)
          expect(saved_image.reload.files.blobs.pluck(:filename).include?(invalid_filename)).to eq(false)
        end

        it "falseを返す" do
          expect(subject).to eq(false)
        end
      end
    end
  end

  describe "#check_and_add_error" do
    subject { review_poster_form_instance.send(:check_and_add_error) }

    context "レビューレコードの属性値が無効な場合" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: invalid_params) }
      let(:invalid_params) { { review_attributes: invalid_review_params, image_attributes: image_params } }

      it "レビューレコードのエラーメッセージがerrorsコレクションに追加される" do
        subject
        expect(review_poster_form_instance.errors[:base]).to include("#{Review.human_attribute_name(:title)}を入力してください")
        expect(review_poster_form_instance.errors[:base]).to include("#{Review.human_attribute_name(:comment)}を入力してください")
        expect(review_poster_form_instance.errors[:base]).to include("#{Review.human_attribute_name(:dog_score)}を入力してください")
        expect(review_poster_form_instance.errors[:base]).to include("#{Review.human_attribute_name(:human_score)}を入力してください")
      end

      it "trueを返す" do
        expect(subject).to eq(true)
      end
    end

    context "イメージレコードの属性値が無効な場合" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: invalid_params) }
      let(:invalid_params) { { review_attributes: review_params, image_attributes: invalid_image_params } }

      it "イメージレコードのエラーメッセージがerrorsコレクションに追加される" do
        subject
        expect(review_poster_form_instance.errors[:base]).to include("#{Image.human_attribute_name(:files)}のファイル形式が不正です。")
      end

      it "trueを返す" do
        expect(subject).to eq(true)
      end
    end

    context "レビューレコードとイメージレコードの属性値が有効な場合" do
      let(:review_poster_form_instance) { ReviewPosterForm.new(attributes: params) }

      it "falseを返す" do
        expect(subject).to eq(false)
      end
    end
  end
end
