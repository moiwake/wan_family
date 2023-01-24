require 'rails_helper'

RSpec.describe SpotRegisterForm, type: :model do
  let(:categories) { create_list(:category, 2) }
  let(:allowed_areas) { create_list(:allowed_area, 2) }
  let(:rule_options) { RuleOption.all.limit(4) }

  let!(:saved_spot) { create(:spot, :with_rules) }
  let!(:saved_rules) { saved_spot.rules }

  let(:params) { { spot_attributes: spot_params, rules_attributes: rules_params } }
  let(:spot_params) { FactoryBot.attributes_for(:spot, allowed_area_id: allowed_areas.first.id, category_id: categories.first.id) }
  let(:rules_params) do
    {
      "#{rule_options[0].id}" => { "answer" => "1" },
      "#{rule_options[1].id}" => { "answer" => "1" },
      "#{rule_options[2].id}" => { "answer" => "0" },
      "#{rule_options[3].id}" => { "answer" => "0" },
    }
  end

  let(:updated_params) { { spot_attributes: updated_spot_params, rules_attributes: updated_rules_params } }
  let(:updated_spot_params) { FactoryBot.attributes_for(:spot, allowed_area_id: allowed_areas.last.id, category_id: categories.last.id) }
  let(:updated_rules_params) do
    {
      "#{rule_options[0].id}" => { "answer" => "0" },
      "#{rule_options[1].id}" => { "answer" => "0" },
      "#{rule_options[2].id}" => { "answer" => "1" },
      "#{rule_options[3].id}" => { "answer" => "1" },
    }
  end

  let(:invalid_params) { { spot_attributes: invalid_spot_params, rules_attributes: { nil => {} } } }
  let(:invalid_spot_params) { FactoryBot.attributes_for(:spot, :invalid_spot) }

  describe "#spot_attributes=" do
    let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: params) }
    let(:spot) { spot_register_form_instance.spot }

    it "パラメータの値をスポットインスタンスの属性値に設定する" do
      expect(spot.name).to eq(spot_params[:name])
      expect(spot.latitude).to eq(spot_params[:latitude])
      expect(spot.longitude).to eq(spot_params[:longitude])
      expect(spot.address).to eq(spot_params[:address])
      expect(spot.official_site).to eq(spot_params[:official_site])
      expect(spot.allowed_area_id).to eq(spot_params[:allowed_area_id])
      expect(spot.category_id).to eq(spot_params[:category_id])
    end
  end

  describe "#rules_attributes=" do
    context "spot_register_form_instanceのrulesオブジェクトがnilのとき" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: params) }
      let(:rules) { spot_register_form_instance.spot.rules }

      it "パラメータのキーの数だけ、同伴ルールのレコードを作成する" do
        expect(rules.length).to eq(rules_params.keys.length)
      end

      it "作成した同伴ルールレコードの属性値に、パラメータの値と指定の外部キーを設定する" do
        rules_params.each.with_index do |(key, value), i|
          expect(rules[i].answer).to eq(value["answer"])
          expect(rules[i].rule_option_id.to_s).to eq(key)
        end
      end
    end

    context "spot_register_form_instanceのrulesオブジェクトがnilではないとき" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: updated_params, spot: saved_spot, rules: saved_rules) }
      let(:rules) { spot_register_form_instance.rules }

      it "パラメータの値を同伴ルールレコードの属性値に設定する" do
        updated_rules_params.each.with_index do |(key, value), i|
          expect(rules[i].answer).to eq(value["answer"])
          expect(rules[i].rule_option_id.to_s).to eq(key)
        end
      end
    end
  end

  describe "#persist" do
    subject { spot_register_form_instance.send(:persist) }

    context "スポット、同伴ルールの属性値が妥当な場合" do
      context "新規登録" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: params) }
        let(:params) { { spot_attributes: spot_params, rules_attributes: rules_params } }

        it "スポットレコードが保存される" do
          expect { subject }.to change { Spot.count }.by(1)
        end

        it "同伴ルールのすべてのレコードが保存される" do
          expect { subject }.to change { Rule.count }.by(spot_register_form_instance.spot.rules.length)
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end

      context "更新" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: updated_params, spot: saved_spot, rules: saved_rules) }

        it "スポットレコードが更新される" do
          saved_spot.reload
          expect { subject }.to change { Spot.count }.by(0)
          expect(saved_spot.saved_change_to_name?).to eq(true)
          expect(saved_spot.saved_change_to_latitude?).to eq(true)
          expect(saved_spot.saved_change_to_longitude?).to eq(true)
          expect(saved_spot.saved_change_to_address?).to eq(true)
          expect(saved_spot.saved_change_to_official_site?).to eq(true)
          expect(saved_spot.saved_change_to_allowed_area_id?).to eq(true)
          expect(saved_spot.saved_change_to_category_id?).to eq(true)
        end

        it "同伴ルールのすべてのレコードが更新される" do
          saved_rules.each(&:reload)
          expect { subject }.to change { Rule.count }.by(0)

          saved_rules.each do |saved_rule|
            expect(saved_rule.saved_change_to_answer?).to eq(true)
          end
        end

        it "trueを返す" do
          expect(subject).to eq(true)
        end
      end
    end

    context "スポット、同伴ルールの属性値が不正な場合" do
      context "新規登録" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_params) }

        it "スポットのレコードは保存されない" do
          expect { subject }.to change { Spot.count }.by(0)
        end

        it "同伴ルールのすべてのレコードが保存されない" do
          expect { subject }.to change { Rule.count }.by(0)
        end

        it "falseを返す" do
          expect(subject).to eq(false)
        end
      end

      context "更新" do
        let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_params, spot: saved_spot, rules: saved_rules) }

        it "スポットのレコードは更新されない" do
          saved_spot.reload
          expect { subject }.to change { Spot.count }.by(0)
          expect(saved_spot.reload.name_changed?).to eq(false)
          expect(saved_spot.address_changed?).to eq(false)
          expect(saved_spot.latitude_changed?).to eq(false)
          expect(saved_spot.longitude_changed?).to eq(false)
          expect(saved_spot.allowed_area_id_changed?).to eq(false)
          expect(saved_spot.category_id_changed?).to eq(false)
          expect(saved_spot.official_site_changed?).to eq(false)
        end

        it "同伴ルールのすべてのレコードが更新されない" do
          saved_rules.each(&:reload)
          expect { subject }.to change { Rule.count }.by(0)

          saved_rules.each do |saved_rule|
            expect(saved_rule.saved_change_to_answer?).to eq(false)
          end
        end

        it "falseを返す" do
          expect(subject).to eq(false)
        end
      end
    end
  end

  describe "#check_and_add_error" do
    subject { spot_register_form_instance.send(:check_and_add_error) }

    context "スポットの属性値が無効な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_params) }
      let(:invalid_params) { { spot_attributes: invalid_spot_params, rules_attributes: rules_params } }

      it "スポットレコードのエラーメッセージがerrorsコレクションに追加される" do
        subject
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:name)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:category)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
      end

      it "addressカラムにエラーがあるとき、latitude、longitudeカラムのエラーはerrorsコレクションに追加されない" do
        subject
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:latitude)}を入力してください")
        expect(spot_register_form_instance.errors[:base]).not_to include("#{Spot.human_attribute_name(:longitude)}を入力してください")
      end
    end

    context "同伴ルールの属性値が無効な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: invalid_params) }
      let(:invalid_params) { { spot_attributes: spot_params, rules_attributes: { nil => {} } } }

      it "同伴ルールレコードのエラーメッセージがerrorsコレクションに追加される" do
        subject
        expect(spot_register_form_instance.errors[:base]).to include("#{Spot.human_attribute_name(:rule)}は不正な値です")
      end
    end

    context "スポットと同伴ルールの属性値が有効な場合" do
      let(:spot_register_form_instance) { SpotRegisterForm.new(attributes: params) }

      it "falseを返す" do
        expect(subject).to eq(false)
      end
    end
  end
end

