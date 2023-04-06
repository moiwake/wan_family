require 'rails_helper'

RSpec.describe SpotDecorator, type: :decorator do
  let!(:spot) { create(:spot) }

  describe "#get_attached_saved_rules" do
    let(:attached_rules) { create_list(:rule, 2, spot_id: spot.id, answer: "1") }
    let(:not_attached_rules) { create_list(:rule, 2, spot_id: spot.id, answer: "0") }

    it "スポットに関連するRuleレコードのうち、スポットに適用されると回答されたレコード群のみを返す"do
      attached_rules.each do |attached_rule|
        expect(spot.decorate.get_attached_saved_rules.include?(attached_rule)).to eq(true)
      end

      not_attached_rules.each do |not_attached_rule|
        expect(spot.decorate.get_attached_saved_rules.include?(not_attached_rule)).to eq(false)
      end
    end
  end

  describe "#get_attached_unsaved_rules" do
    let(:attached_rules) { spot.rules.build([{ answer: "1" }, { answer: "1" }]) }
    let(:not_attached_rules) { spot.rules.build([{ answer: "0" }, { answer: "0" }]) }

    it "スポットに関連するRuleレコードのうち、スポットに適用されると回答されたレコード群のみを返す"do
      attached_rules.each do |attached_rule|
        expect(spot.decorate.get_attached_unsaved_rules.include?(attached_rule)).to eq(true)
      end

      not_attached_rules.each do |not_attached_rule|
        expect(spot.decorate.get_attached_unsaved_rules.include?(not_attached_rule)).to eq(false)
      end
    end
  end

  describe "#get_dog_score_avg" do
    context "スポットに関連するReviewレコードが存在するとき" do
      let(:review_1) { create(:review, dog_score: 1, spot_id: spot.id) }
      let(:review_2) { create(:review, dog_score: 3, spot_id: spot.id) }
      let(:review_3) { create(:review, dog_score: 3, spot_id: spot.id) }
      let!(:review_ary) { [review_1.dog_score, review_2.dog_score, review_3.dog_score] }

      it "dog_scoreカラムの平均値を、小数点第一位で四捨五入した値を返す" do
        expect(spot.decorate.get_dog_score_avg).to eq((review_ary.sum.to_f / review_ary.length).round(1))
      end
    end

    context "スポットに関連するReviewレコードが存在しないとき" do
      it "nilを返す" do
        expect(spot.decorate.get_dog_score_avg).to eq(nil)
      end
    end
  end

  describe "#get_human_score_avg" do
    context "スポットに関連するReviewレコードが存在するとき" do
      let(:review_1) { create(:review, human_score: 1, spot_id: spot.id) }
      let(:review_2) { create(:review, human_score: 3, spot_id: spot.id) }
      let(:review_3) { create(:review, human_score: 3, spot_id: spot.id) }
      let!(:review_ary) { [review_1.human_score, review_2.human_score, review_3.human_score] }

      it "human_scoreカラムの平均値を、小数点第一位で四捨五入した値を返す" do
        expect(spot.decorate.get_human_score_avg).to eq((review_ary.sum.to_f / review_ary.length).round(1))
      end
    end

    context "スポットに関連するReviewレコードが存在しないとき" do
      it "nilを返す" do
        expect(spot.decorate.get_human_score_avg).to eq(nil)
      end
    end
  end
end
