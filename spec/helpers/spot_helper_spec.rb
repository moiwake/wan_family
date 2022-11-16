require 'rails_helper'

RSpec.describe SpotsHelper, type: :helper do
  describe "#ary_present_and_include_ele?" do
    let(:ary) { [1, 2, 3] }

    context "引数に渡された配列が存在するとき" do
      context "その配列に、引数に渡された値が含まれていれば" do
        it "trueを返す" do
          expect(helper.ary_present_and_include_ele?(ary: ary, ele: 1)).to eq(true)
        end
      end

      context "その配列に、引数に渡された値が含まれていなければ" do
        it "falseを返す" do
          expect(helper.ary_present_and_include_ele?(ary: ary, ele: 0)).to eq(false)
        end
      end
    end

    context "引数に渡された配列が存在しないとき" do
      it "falseを返す" do
        expect(helper.ary_present_and_include_ele?(ary: nil)).to eq(false)
      end
    end
  end
end
