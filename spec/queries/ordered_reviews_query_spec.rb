require 'rails_helper'

RSpec.describe OrderedReviewsQuery, type: :model do
  before { FactoryBot.create_list(:review, 3) }

  describe "#call" do
    context "引数なしでcallメソッドを呼び出すとき" do
      let(:ordered_reviews_query_instance) { OrderedReviewsQuery.new(default_arguments) }
      let(:default_arguments) { { scope: Review.all, parent_record: nil, order_params: {}, like_class: "LikeReview" } }

      before do
        allow(OrderedReviewsQuery).to receive(:new).and_return(ordered_reviews_query_instance)
        OrderedReviewsQuery.call
      end

      it "デフォルト値を引数に渡して、newメソッドを呼び出す" do
        expect(OrderedReviewsQuery).to have_received(:new).once.with(default_arguments)
      end
    end
  end

  describe "#set_scope" do
    let(:scope) { Review.all }
    let(:ordered_reviews_query_instance) { OrderedReviewsQuery.new(scope: scope, parent_record: parent_record, order_params: {}, like_class: "LikeReview") }

    subject(:return_value) { ordered_reviews_query_instance.send(:set_scope) }

    context "parent_recordがnilのとき" do
      let(:parent_record) { nil }

      it "Reviewレコード群をそのまま返す" do
        expect(return_value).to eq(scope)
      end
    end

    context "parent_recordがUserクラスのオブジェクトのとき" do
      let(:parent_record) { User.find(scope[0].user_id) }

      it "parent_recordのレコードと関連するReviewレコード群を返す" do
        expect(return_value).to eq(scope.where(user_id: parent_record.id))
      end
    end

    context "parent_recordがSpotクラスのオブジェクトのとき" do
      let(:parent_record) { Spot.find(scope[0].spot_id) }

      it "parent_recordのレコードと関連するReviewレコード群を返す" do
        expect(return_value).to eq(scope.where(spot_id: parent_record.id))
      end
    end
  end
end
