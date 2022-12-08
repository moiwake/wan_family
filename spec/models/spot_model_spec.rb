require "rails_helper"
require 'support/shared_examples'

RSpec.describe Spot, type: :model do
  let!(:spot) { create(:spot, :real_spot) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(spot).to be_valid
    end
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
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "nameカラムが重複しているとき" do
      let(:attribute) { :name }
      let(:invalid_object) { build(:spot, :duplicated_name) }

      it_behaves_like "adds validation error messages"
    end

    context "latitudeカラムとlongitudeカラムの両データが重複しているとき" do
      let(:attribute) { :latitude }
      let(:invalid_object) { build(:spot, :duplicated_latlng) }

      it_behaves_like "adds validation error messages"
    end

    context "latitudeカラムのデータのみが重複しているとき" do
      let(:attribute) { :latitude }
      let(:valid_spot) { build(:spot, :duplicated_latitude) }

      it "そのスポットデータは有効" do
        expect(valid_spot).to be_valid
      end
    end

    context "longitudeカラムがのみ重複しているとき" do
      let(:attribute) { :longitude }
      let(:valid_spot) { build(:spot, :duplicated_longitude) }

      it "そのスポットデータは有効" do
        expect(valid_spot).to be_valid
      end
    end

    context "addressカラムが重複しているとき" do
      let(:attribute) { :address }
      let(:invalid_object) { build(:spot, :duplicated_address) }

      it_behaves_like "adds validation error messages"
    end
  end
end

