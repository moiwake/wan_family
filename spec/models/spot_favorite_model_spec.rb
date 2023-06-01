require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe SpotFavorite, type: :model do
  let!(:spot_favorite) { create(:spot_favorite) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { spot_favorite }

    it_behaves_like "有効なオブジェクトか"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot_favorite, attribute => nil) }
    let(:message) { "を入力してください" }

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        it_behaves_like "バリデーションエラーメッセージ"
      end
    end

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        it_behaves_like "バリデーションエラーメッセージ"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "user_idカラムとspot_idカラムの組み合わせが重複しているとき" do
      let(:attribute) { :user }
      let(:invalid_object) { build(:spot_favorite, user_id: spot_favorite.user_id, spot_id: spot_favorite.spot_id) }

      it_behaves_like "バリデーションエラーメッセージ"
    end

    context "user_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:spot_favorite, user_id: spot_favorite.user_id) }

      it_behaves_like "有効なオブジェクトか"
    end

    context "spot_idカラムのみが重複しているとき" do
      let(:valid_object) { build(:spot_favorite, spot_id: spot_favorite.spot_id) }

      it_behaves_like "有効なオブジェクトか"
    end
  end

  describe "Spotモデルに対するcounter_cacheオプション" do
    context "レコードが保存されたとき" do
      let(:spot_favorite) { build(:spot_favorite, spot: spot) }
      let(:spot) { create(:spot) }

      it "関連するSpotレコードのspot_helphulnesses_countカラムの値が1つ増える" do
        expect { spot_favorite.save }.to change { spot.spot_favorites_count }.by(1)
      end
    end

    context "レコードが削除されたとき" do
      let(:spot_favorite) { create(:spot_favorite, spot: spot) }
      let(:spot) { create(:spot) }

      it "関連するSpotレコードのspot_helphulnesses_countカラムの値が1つ減る" do
        expect { spot_favorite.destroy }.to change { spot.spot_favorites_count }.by(-1)
      end
    end
  end
end
