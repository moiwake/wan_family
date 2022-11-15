require "rails_helper"

shared_examples "validation error message" do
  it "errorsコレクションにエラーメッセージが追加される" do
    invalid_allowed_area.valid?
    expect(invalid_allowed_area.errors[attribute]).to include(message)
  end
end

RSpec.describe AllowedArea, type: :model do
  let!(:allowed_area) { create(:allowed_area) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(allowed_area).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_allowed_area) { build(:allowed_area, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "areaカラム" do
      let(:attribute) { :area }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "validation error message"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "validation error message"
      end
    end
  end

  describe "uniquenessのバリデーション" do
    let(:message) { "はすでに存在します" }

    context "areaカラムが重複しているとき" do
      let(:attribute) { :area }
      let(:invalid_allowed_area) { build(:allowed_area, area: allowed_area.area) }

      it_behaves_like "validation error message"
    end
  end
end
