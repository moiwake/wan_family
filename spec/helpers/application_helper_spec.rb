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
      it "'user'を返す" do
        allow(helper).to receive(:current_user).and_return(user)
        expect(helper.who_signed_in?).to eq("user")
      end
    end

    context "ログインしている管理者が存在するとき" do
      it "'admin'を返す" do
        allow(helper).to receive(:current_admin).and_return(admin)
        expect(helper.who_signed_in?).to eq("admin")
      end
    end

    context "ログインしていないとき" do
      it "nilを返す" do
        expect(helper.who_signed_in?).to eq(nil)
      end
    end
  end
end
