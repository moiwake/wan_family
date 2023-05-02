require 'rails_helper'

RSpec.describe FormBase, type: :model do
  let(:child_class_instance) { ChildClass.new }

  before do
    child_class = Class.new(FormBase) do
      attr_accessor :spot

      def initialize(attributes: nil, spot: Spot.new)
        @spot = spot
        super(attributes: attributes, record: spot)
      end
    end
    stub_const("ChildClass", child_class)
  end

  describe "#initialize" do
    context "引数が渡されていないとき" do
      it "変数attributesにdefault_attributesメソッドの返り値が代入される" do
        expect(child_class_instance.attributes).to eq(child_class_instance.send(:default_attributes))
      end
    end
  end

  describe "#invalid?" do
    before { allow(child_class_instance).to receive(:check_and_add_errors) }

    it "check_and_add_errorメソッドを呼び出す" do
      child_class_instance.invalid?
      expect(child_class_instance).to have_received(:check_and_add_errors).once
    end
  end

  describe "#save" do
    before { allow(child_class_instance).to receive(:persist) }

    it "persistメソッドを呼び出す" do
      child_class_instance.save
      expect(child_class_instance).to have_received(:persist).once
    end
  end

  describe "#check_and_add_errors" do
    subject(:return_value) { child_class_instance.send(:check_and_add_errors) }

    context "レコードの属性値が有効なとき" do
      let!(:allowed_area) { create(:allowed_area) }
      let!(:category) { create(:category) }
      let!(:prefecture) { create(:prefecture) }

      before do
        child_class_instance.record.assign_attributes(
          attributes_for(:spot, allowed_area_id: allowed_area.id, category_id: category.id, prefecture_id: prefecture.id)
        )
      end

      it "falseを返す" do
        expect(return_value).to eq(false)
      end
    end

    context "レコードの属性値が不正なとき" do
      before { allow(child_class_instance).to receive(:add_errors) }

      it "add_errorsメソッドを呼び出す" do
        subject
        expect(child_class_instance).to have_received(:add_errors).once
      end
    end
  end

  describe "#add_errors" do
    before do
      child_class_instance.record.invalid?
      child_class_instance.send(:add_errors)
    end

    it "レコードのエラーメッセージがerrorsコレクションに追加される" do
      expect(child_class_instance.errors[:base]).to include("#{Spot.human_attribute_name(:name)}を入力してください")
      expect(child_class_instance.errors[:base]).to include("#{Spot.human_attribute_name(:address)}を入力してください")
      expect(child_class_instance.errors[:base]).to include("#{Spot.human_attribute_name(:category)}を入力してください")
      expect(child_class_instance.errors[:base]).to include("#{Spot.human_attribute_name(:allowed_area)}を入力してください")
    end
  end

  describe "#persist" do
    subject(:return_value) { child_class_instance.send(:persist) }

    context "check_and_add_errorsメソッドの返り値がfalseのとき" do
      let!(:allowed_area) { create(:allowed_area) }
      let!(:category) { create(:category) }
      let!(:prefecture) { create(:prefecture) }

      before do
        child_class_instance.record.assign_attributes(
          attributes_for(:spot, allowed_area_id: allowed_area.id, category_id: category.id, prefecture_id: prefecture.id)
        )
      end

      it "レコードが保存される" do
        expect { subject }.to change { Spot.count }.by(1)
      end

      it "trueを返す" do
        expect(return_value).to eq(true)
      end
    end

    context "check_and_add_errorsメソッドの返り値がtrueのとき" do
      it "レコードは保存されない" do
        expect { subject }.to change { Spot.count }.by(0)
      end

      it "falseを返す" do
        expect(return_value).to eq(false)
      end
    end
  end
end
