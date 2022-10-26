require "rails_helper"

shared_examples "validation error message" do
  it "エラーになる" do
    invalid_spot.valid?
    expect(invalid_spot.errors[attribute]).to include(message)
  end
end

RSpec.describe Spot, type: :model do
  let!(:spot) { create(:spot) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(spot).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_spot) { build(:spot, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "latitudeカラム" do
      let(:attribute) { :latitude }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "longitudeカラム" do
      let(:attribute) { :longitude }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "addressカラム" do
      let(:attribute) { :address }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end

    context "allowed_areaカラム" do
      let(:attribute) { :allowed_area }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end

    context "categoryカラム" do
      let(:attribute) { :category }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "latitudeカラムとlongitudeカラムの両データが重複しているとき" do
      let(:attribute) { :latitude }
      let(:invalid_spot) { build(:spot, :duplicated_latlng) }

      it_behaves_like "validation error message"
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
      let(:invalid_spot) { build(:spot, :duplicated_address) }

      it_behaves_like "validation error message"
    end
  end
end

