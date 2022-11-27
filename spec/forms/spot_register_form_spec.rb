require 'rails_helper'

RSpec.describe SpotRegisterForm, type: :model do
  let!(:new_spot) { Spot.new }
  let!(:saved_spot) { create(:spot, :with_rules) }
  let!(:saved_rules) { saved_spot.rule }

  let(:spot_attributes) { FactoryBot.attributes_for(:spot, allowed_area_id: AllowedArea.first.id, category_id: Category.first.id) }
  let(:rules_attributes) do
    keys = RuleOption.pluck(:id).map(&:to_s)
    values = rules_attributes_values
    keys.zip(values).to_h
  end
  let(:rules_attributes_values) do
    RuleOption.pluck(:id).map do |id|
      FactoryBot.attributes_for(:rule, rule_option_id: id)
    end
  end

  describe "#persist" do
    subject { spot_register_form_instance.send(:persist) }

    context "スポット、同伴ルールの属性値が妥当な場合" do
      context "新規登録" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: attributes, spot: new_spot) }
        let(:attributes) { { spot_attributes: spot_attributes, rules_attributes: rules_attributes } }

        it "パラメータの値を属性値に設定して、スポットのレコードが保存される" do
          expect do
            subject
          end.to change { Spot.count }.by(1)

          expect(new_spot.name).to eq(spot_attributes[:name])
          expect(new_spot.latitude).to eq(spot_attributes[:latitude])
          expect(new_spot.longitude).to eq(spot_attributes[:longitude])
          expect(new_spot.address).to eq(spot_attributes[:address])
          expect(new_spot.official_site).to eq(spot_attributes[:official_site])
          expect(new_spot.allowed_area_id).to eq(spot_attributes[:allowed_area_id])
          expect(new_spot.category_id).to eq(spot_attributes[:category_id])
        end

        it "パラメータの値を属性値に設定して、同伴ルールのすべてのレコードが保存される" do
          expect do
            subject
          end.to change { Rule.count }.by(spot_register_form_instance.spot.rule.length)

          new_spot.rule.each do |new_rule|
            expect(new_rule.answer).to eq(rules_attributes[new_rule.rule_option_id.to_s][:answer])
            expect(new_rule.rule_option_id).to eq(rules_attributes[new_rule.rule_option_id.to_s][:rule_option_id])
          end
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end

      context "更新" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: attributes, spot: saved_spot, rules: saved_rules) }
        let(:attributes) { { spot_attributes: spot_attributes, rules_attributes: rules_attributes } }

        it "パラメータの値を属性値に設定して、スポットのレコードが更新される" do
          expect do
            subject
            expect(saved_spot.name).to eq(spot_attributes[:name])
            expect(saved_spot.latitude).to eq(spot_attributes[:latitude])
            expect(saved_spot.longitude).to eq(spot_attributes[:longitude])
            expect(saved_spot.address).to eq(spot_attributes[:address])
            expect(saved_spot.official_site).to eq(spot_attributes[:official_site])
            expect(saved_spot.allowed_area_id).to eq(spot_attributes[:allowed_area_id])
            expect(saved_spot.category_id).to eq(spot_attributes[:category_id])
          end.to change { Spot.count }.by(0)
        end

        it "同伴ルールのすべてレコードが更新される" do
          expect do
            subject
            saved_rules.each do |saved_rule|
              expect(saved_rule.answer).to eq(rules_attributes[saved_rule.rule_option_id.to_s][:answer])
              expect(saved_rule.rule_option_id).to eq(rules_attributes[saved_rule.rule_option_id.to_s][:rule_option_id])
            end
          end.to change { Rule.count }.by(0)
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end
    end

    context "スポット、同伴ルールの属性値が不正な場合" do
      let(:invalid_attributes) { { spot_attributes: invalid_spot_attributes, rules_attributes: { nil => {} } } }
      let(:invalid_spot_attributes) { FactoryBot.attributes_for(:spot, :invalid_spot) }

      context "新規登録" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_attributes) }

        it "スポットのレコードは保存されない" do
          expect do
            subject
          end.to change { Spot.count }.by(0)
        end

        it "同伴ルールのすべてのレコードが保存されない" do
          expect do
            subject
          end.to change { Rule.count }.by(0)
        end

        it "falseを返す" do
          expect(subject).to eq(false)
        end
      end

      context "更新" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_attributes, spot: saved_spot, rules: saved_rules) }

        it "スポットのレコードは更新されない" do
          expect do
            subject
            expect(saved_spot.reload.name_changed?).to eq(false)
            expect(saved_spot.address_changed?).to eq(false)
            expect(saved_spot.latitude_changed?).to eq(false)
            expect(saved_spot.longitude_changed?).to eq(false)
            expect(saved_spot.allowed_area_id_changed?).to eq(false)
            expect(saved_spot.category_id_changed?).to eq(false)
            expect(saved_spot.official_site_changed?).to eq(false)
          end.to change { Rule.count }.by(0)
        end

        it "同伴ルールのすべてのレコードが更新されない" do
          expect do
            subject
            saved_rules.each do |saved_rule|
              expect(saved_rule.answer_changed?).to eq(false)
            end
          end.to change { Rule.count }.by(0)
        end

        it "falseを返す" do
          subject
          expect(subject).to eq(false)
        end
      end
    end
  end

  describe "#check_and_add_error" do
    subject { spot_register_form_instance.send(:check_and_add_error) }

    context "スポット、もしくは同伴ルールの属性値が無効な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_attributes) }

      context "スポットの属性値が無効な場合" do
        let(:invalid_attributes) { { spot_attributes: invalid_spot_attributes, rules_attributes: rules_attributes } }
        let(:invalid_spot_attributes) { FactoryBot.attributes_for(:spot, :invalid_spot) }

        it "スポットの属性に関するエラーメッセージがerrorsコレクションに追加される" do
          subject
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:name)}を入力してください")
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:category)}を入力してください")
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
        end

        it "addressの属性値にエラーがあるとき、latitude、longitudeのエラーはerrorsコレクションに追加されない" do
          subject
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
          expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:latitude)}を入力してください")
          expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:longitude)}を入力してください")
        end
      end

      context "同伴ルールの属性値が無効な場合" do
        let(:invalid_attributes) { { spot_attributes: spot_attributes, rules_attributes: { nil => {} } } }

        it "同伴ルールの属性に関するエラーメッセージがerrorsコレクションに追加される" do
          subject
          expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:rule)}は不正な値です")
        end
      end
    end

    context "スポット、もしくは同伴ルールの属性値が有効な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: attributes) }
      let(:attributes) { { spot_attributes: spot_attributes, rules_attributes: rules_attributes } }

      it "falseを返す" do
        expect(subject).to eq(false)
      end
    end
  end
end
