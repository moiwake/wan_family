require "rails_helper"
require 'support/shared_examples'

RSpec.describe SpotHistory, type: :model do
  let!(:spot_history) { create(:spot_history) }

  context "全カラムのデータが有効なとき" do
    it "そのスポットのデータは有効" do
      expect(spot_history).to be_valid
    end
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot_history, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "spotカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "userカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "historyカラム" do
      let(:attribute) { :history }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end
  end
end
