require 'rails_helper'

RSpec.describe OrderedReviewsQuery, type: :model do
  let!(:reviews) { create_list(:review, 3) }
  let!(:scope) { Review.all }

  describe "#call" do
    let(:user) { instance_double("user") }
    let(:order_params) { {} }

    before do
      allow(OrderedReviewsQuery).to receive(:set_default_scope).and_return(reviews)
      allow(OrderedReviewsQuery).to receive(:search_by_parent_record).and_return(reviews)
      allow(OrderedReviewsQuery).to receive(:order_scope).and_return(reviews)
      OrderedReviewsQuery.send(:call, reviews: reviews, parent_record: user, order_params: order_params)
    end

    it "引数の値を渡してset_default_scopeメソッドを呼び出す" do
      expect(OrderedReviewsQuery).to have_received(:set_default_scope).once.with(reviews)
    end

    it "引数の値を渡してsearch_by_parent_recordメソッドを呼び出す" do
      expect(OrderedReviewsQuery).to have_received(:search_by_parent_record).once.with(reviews, user)
    end

    it "引数の値を渡してorder_scopeメソッドを呼び出す" do
      expect(OrderedReviewsQuery).to have_received(:order_scope).once.with(reviews, order_params)
    end
  end

  describe "#set_default_scope" do
    subject { OrderedReviewsQuery.send(:set_default_scope, scope) }

    before do
      allow(OrderedReviewsQuery).to receive(:eager_load_associations).and_return(scope)
      allow(OrderedReviewsQuery).to receive(:preload_like_reviews)
    end

    it "引数の値を渡してeager_load_associationsメソッドを呼び出す" do
      subject
      expect(OrderedReviewsQuery).to have_received(:eager_load_associations).once.with(scope)
    end

    it "引数の値を渡してpreload_like_reviewsメソッドを呼び出す" do
      subject
      expect(OrderedReviewsQuery).to have_received(:preload_like_reviews).once.with(scope)
    end
  end

  describe "#eager_load_associations" do
    let!(:image) { create(:image, :attached, review_id: scope[0].id) }

    subject { OrderedReviewsQuery.send(:eager_load_associations, scope) }

    it "Reviewレコード群を返す" do
      expect(subject.class.name).to eq("ActiveRecord::Relation")
      expect(subject.pluck(:id)).to eq(scope.pluck(:id))
    end

    it "引数に1対1の関係にあるモデルのテーブルをeager loadingする" do
      expect(subject[0].association(:user).loaded?).to eq(true)
      expect(subject[0].association(:spot).loaded?).to eq(true)
      expect(subject[0].association(:image).loaded?).to eq(true)
      expect(subject[0].image.association(:files_attachments).loaded?).to eq(true)
      expect(subject[0].image.files[0].association(:blob).loaded?).to eq(true)
      expect(subject[0].image.files[0].blob.association(:variant_records).loaded?).to eq(true)
    end
  end

  describe "preload_like_reviews" do
    subject { OrderedReviewsQuery.send(:preload_like_reviews, scope) }

    it "Reviewレコード群を返す" do
      expect(subject).to eq(scope)
    end

    it "引数にlike_reviewsテーブルをpreloadする" do
      expect(subject[0].association(:like_reviews).loaded?).to eq(true)
    end
  end

  describe "#search_by_parent_record" do
    context "引数parent_recordがnilのとき" do
      let(:parent_record) { nil }

      it "引数に渡されたReviewレコード群をそのまま返す" do
        expect(OrderedReviewsQuery.send(:search_by_parent_record, scope, parent_record)).to eq(scope)
      end
    end

    context "引数parent_recordがUserクラスのオブジェクトのとき" do
      let(:parent_record) { create(:user) }
      let(:searched_scope) { scope.where(user_id: parent_record.id) }

      it "parent_recordのレコードと関連するReviewレコード群を返す" do
        expect(OrderedReviewsQuery.send(:search_by_parent_record, scope, parent_record)).to eq(searched_scope)
      end
    end

    context "引数parent_recordがSpotクラスのオブジェクトのとき" do
      let(:parent_record) { create(:spot) }
      let(:searched_scope) { scope.where(spot_id: parent_record.id) }

      it "parent_recordのレコードと関連するReviewレコード群を返す" do
        expect(OrderedReviewsQuery.send(:search_by_parent_record, scope, parent_record)).to eq(searched_scope)
      end
    end
  end

  describe "#set_ids_in_order_likes" do
    let!(:like_review_A) { create_list(:like_review, 3, review_id: reviews[0].id) }
    let!(:like_review_B) { create_list(:like_review, 2, review_id: reviews[1].id) }
    let!(:like_review_C) { create_list(:like_review, 1, review_id: reviews[2].id) }
    let(:ordered_like_ids) { [reviews[0].id, reviews[1].id, reviews[2].id] }

    it "同じreview_idを持つLikeReviewレコードの数が多い順に、review_idの配列を返す" do
      expect(OrderedReviewsQuery.send(:set_ids_in_order_likes)).to eq(ordered_like_ids)
    end
  end
end
