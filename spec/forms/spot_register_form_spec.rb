require 'rails_helper'

RSpec.describe SpotRegisterForm, type: :model do
  let!(:categories) { create_list(:category, 2) }
  let!(:allowed_areas) { create_list(:allowed_area, 2) }
  let!(:prefecture) { create(:prefecture, :real_prefecture) }

  describe "#spot_attributes=" do
    subject(:return_value) { spot_register_form_instance.send(:merge_prefecture_id, spot_attributes) }

    let(:spot_attributes) { attributes_for(:spot, :real_spot, allowed_area_id: allowed_areas[0].id, category_id: categories[0].id).stringify_keys }
    let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { "spot_attributes" => spot_attributes }) }
    let(:spot) { spot_register_form_instance.spot }

    before { allow(spot_register_form_instance).to receive(:merge_prefecture_id).and_return(spot_attributes.merge({ "prefecture_id" => prefecture.id })) }

    it "merge_prefecture_idメソッドの返り値をSpotレコードの属性値に設定する" do
      expect(spot.name).to eq(return_value["name"])
      expect(spot.latitude).to eq(return_value["latitude"])
      expect(spot.longitude).to eq(return_value["longitude"])
      expect(spot.address).to eq(return_value["address"])
      expect(spot.official_site).to eq(return_value["official_site"])
      expect(spot.allowed_area_id).to eq(return_value["allowed_area_id"])
      expect(spot.category_id).to eq(return_value["category_id"])
      expect(spot.prefecture_id).to eq(return_value["prefecture_id"])
    end
  end

  describe "#rules_attributes=" do
    let!(:saved_spot) { create(:spot, :with_rules) }
    let!(:rule_option_ids) { saved_spot.rules.pluck(:rule_option_id) }
    let(:rules_attributes) do
      {
        "#{rule_option_ids[0]}" => { "answer" => "0" },
        "#{rule_option_ids[1]}" => { "answer" => "1" },
        "#{rule_option_ids[2]}" => { "answer" => "0" },
        "#{rule_option_ids[3]}" => { "answer" => "1" },
      }
    end
    let(:rules) { spot_register_form_instance.spot.rules }

    context "Spotレコードが未保存のとき" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { "rules_attributes" => rules_attributes }) }

      it "パラメータのキーの数だけ、同伴ルールのレコードを作成する" do
        expect(rules.length).to eq(rules_attributes.keys.length)
      end

      it "作成したRuleレコードの属性値に、パラメータの値を設定する" do
        rules_attributes.each.with_index do |(key, value), i|
          expect(rules[i].answer).to eq(value["answer"])
          expect(rules[i].rule_option_id.to_s).to eq(key)
        end
      end
    end

    context "Spotレコードが保存済のとき" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { "rules_attributes" => rules_attributes }, spot: saved_spot) }

      it "Ruleレコードのanswerカラムに、パラメータの値を設定する" do
        rules_attributes.each.with_index do |(key, value), i|
          expect(rules[i].answer).to eq(value["answer"])
          expect(rules[i].rule_option_id.to_s).to eq(key)
        end
      end
    end
  end

  describe "#add_errors" do
    before do
      spot_register_form_instance.spot.invalid?
      spot_register_form_instance.send(:add_errors)
    end

    context "Spotレコードの属性値が不正な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { spot_attributes: {} }) }

      it "addressカラムにエラーがあるとき、latitude、longitudeカラムのエラーはerrorsコレクションに追加されない" do
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:latitude)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:longitude)}を入力してください")
      end
    end

    context "Ruleレコードの属性値が不正な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { spot_attributes: {}, rules_attributes: { "" => { "answer" => "" } } }) }

      it "同伴ルールレコードのエラーメッセージがerrorsコレクションに追加される" do
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:rules_answer)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:rules_rule_option)}を入力してください")
      end
    end
  end

  describe "#merge_prefecture_id" do
    subject(:return_value) { spot_register_form_instance.send(:merge_prefecture_id, attributes_missing_pref_id) }

    let(:attributes_missing_pref_id) { attributes_for(:spot, :real_spot, allowed_area_id: allowed_areas[0].id, category_id: categories[0].id).stringify_keys }
    let(:attributes_merged_pref_id) { attributes_missing_pref_id.merge({ "prefecture_id" => prefecture.id }) }
    let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: { "spot_attributes" => attributes_missing_pref_id }) }

    context "パラメータに所在地のデータが存在するとき" do
      it "Spotレコードの属性値のハッシュに、prefecture_id属性を追加したハッシュを返す" do
        expect(return_value).to eq(attributes_merged_pref_id)
      end
    end

    context "パラメータに所在地のデータが存在しないとき" do
      before { attributes_missing_pref_id.delete("address") }

      it "Spotレコードの属性値のハッシュをそのまま返す" do
        expect(return_value).to eq(attributes_missing_pref_id)
      end
    end
  end
end
