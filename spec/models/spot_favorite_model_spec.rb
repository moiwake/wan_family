require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe SpotFavorite, type: :model do
  let!(:spot_favorite) { create(:spot_favorite) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { spot_favorite }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot_favorite, attribute => nil) }
    let(:message) { "を入力してください" }

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとspot_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:spot_favorite, user_id: spot_favorite.user_id, spot_id: spot_favorite.spot_id) }

      it_behaves_like "adds validation error messages"
    end

    context "user_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:spot_favorite, user_id: spot_favorite.user_id) }

      it_behaves_like "the object is valid"
    end

    context "spot_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:spot_favorite, spot_id: spot_favorite.spot_id) }

      it_behaves_like "the object is valid"
    end
  end
end
