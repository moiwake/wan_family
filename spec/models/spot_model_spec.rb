require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe Spot, type: :model do
  let!(:spot) { create(:spot) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { spot }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "latitudeカラム" do
      let(:attribute) { :latitude }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "longitudeカラム" do
      let(:attribute) { :longitude }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "addressカラム" do
      let(:attribute) { :address }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "allowed_areaカラム" do
      let(:attribute) { :allowed_area }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "categoryカラム" do
      let(:attribute) { :category }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "prefectureカラム" do
      let(:attribute) { :prefecture }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:spot, name: spot.name) }

      it_behaves_like "adds validation error messages"
    end

    context "latitudeカラムとlongitudeカラムの両データが重複しているとき" do
      let(:attribute) { :latitude }
      let(:invalid_object) { build(:spot, latitude: spot.latitude, longitude: spot.longitude) }

      it_behaves_like "adds validation error messages"
    end

    context "latitudeカラムのデータのみが重複しているとき" do
      let(:attribute) { :latitude }
      let(:valid_object) { build(:spot, latitude: spot.latitude) }

      it_behaves_like "the object is valid"
    end

    context "longitudeカラムがのみ重複しているとき" do
      let(:attribute) { :longitude }
      let(:valid_object) { build(:spot, longitude: spot.longitude) }

      it_behaves_like "the object is valid"
    end

    context "addressカラムが重複しているとき" do
      let(:attribute) { :address }
      let(:invalid_object) { build(:spot, address: spot.address) }

      it_behaves_like "adds validation error messages"
    end
  end

  describe "formatのバリデーション" do
    context "official_siteカラムのパターンが不正なとき" do
      let(:message) { "URLは「http:」もしくは「https:」から始めてください" }
      let(:attribute) { :official_site }
      let(:invalid_object) { build(:spot, official_site: "invalid/url") }

      it_behaves_like "adds validation error messages"
    end
  end
end

