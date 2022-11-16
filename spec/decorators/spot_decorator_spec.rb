require 'rails_helper'

RSpec.describe SpotDecorator, type: :decorator do
  let(:spot) { create(:spot) }

  describe "#find_attached_rules" do
    let(:attached_rules) { create_list(:rule, 2, spot_id: spot.id, answer: "1") }
    let(:not_attached_rules) { create_list(:rule, 2, spot_id: spot.id, answer: "0") }

    it "あるスポットに紐付いた、保存済みの同伴ルールのレコードうち、スポットに適用されると回答されたものを取得する"do
      attached_rules.each do |attached_rule|
        expect(spot.decorate.find_attached_rules.include?(attached_rule)).to eq(true)
      end

      not_attached_rules.each do |not_attached_rule|
        expect(spot.decorate.find_attached_rules.include?(not_attached_rule)).to eq(false)
      end
    end
  end

  describe "#get_checked_rule_opt" do
    let(:attached_rules) { spot.rule.build([{ answer: "1" }, { answer: "1" }]) }
    let(:not_attached_rules) { spot.rule.build([{ answer: "0" }, { answer: "0" }]) }

    it "あるスポットに紐付いた、保存前の同伴ルールのレコードうち、スポットに適用されると回答されたものを配列で取得する"do
      attached_rules.each do |attached_rule|
        expect(spot.decorate.get_checked_rule_opt.include?(attached_rule)).to eq(true)
      end

      not_attached_rules.each do |not_attached_rule|
        expect(spot.decorate.get_checked_rule_opt.include?(not_attached_rule)).to eq(false)
      end
    end
  end
end
