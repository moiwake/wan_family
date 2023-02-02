require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe FavoriteSpot, type: :model do
  let!(:favorite_spot) { create(:favorite_spot) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { favorite_spot }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:favorite_spot, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとspot_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:favorite_spot, user_id: favorite_spot.user_id, spot_id: favorite_spot.spot_id) }

      it_behaves_like "adds validation error messages"
    end

    context "user_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:favorite_spot, user_id: favorite_spot.user_id) }

      it_behaves_like "the object is valid"
    end

    context "spot_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:favorite_spot, spot_id: favorite_spot.spot_id) }

      it_behaves_like "the object is valid"
    end
  end
end
