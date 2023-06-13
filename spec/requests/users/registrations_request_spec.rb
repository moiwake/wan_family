require 'rails_helper'

RSpec.describe "Registration", type: :request do
  let(:guest_user) { User.guest }
  let(:user) { create(:user) }

  describe "#ensure_normal_user" do
    context "ゲストユーザーがログインしているとき" do
      before do
        sign_in guest_user
        delete user_registration_path
      end

      it "トップページにリダイレクトする" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "ゲストユーザー以外がログインしているとき" do
      before do
        sign_in user
        delete user_registration_path
      end

      it "destroyアクションを実行する" do
        expect(user.persisted?).to eq(false)
      end
    end
  end
end
