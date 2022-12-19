require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#who_signed_in?" do
    let(:user) { double("user") }
    let(:admin) { double("admin") }

    before do
      allow(helper).to receive(:current_user).and_return(nil)
      allow(helper).to receive(:current_admin).and_return(nil)
    end

    context "ログインしているユーザーが存在するとき" do
      it "userを返す" do
        allow(helper).to receive(:current_user).and_return(user)
        expect(helper.who_signed_in?).to eq("user")
      end
    end

    context "ログインしている管理者が存在するとき" do
      it "adminを返す" do
        allow(helper).to receive(:current_admin).and_return(admin)
        expect(helper.who_signed_in?).to eq("admin")
      end
    end

    context "ログインしていないとき" do
      it "othersを返す" do
        expect(helper.who_signed_in?).to eq("others")
      end
    end
  end

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

  describe "#get_prefecture_name" do
    it "地方名が引数の値と一致するデータの県名を、配列で取得する" do
      expect(helper.get_prefecture_name("東北")).to eq(["青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"])
    end
  end
end
