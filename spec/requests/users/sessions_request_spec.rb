require 'rails_helper'

RSpec.describe "Session", type: :request do
  let(:guest_user_email) { "guest@example.com" }

  describe "POST /guest_sign_in" do
    before { post users_guest_sign_in_path }

    it "ゲストユーザーでログインする" do
      get root_path
      expect(response.body).to include("ゲストユーザー")
    end

    it "トップページにリダイレクトする" do
      expect(response).to redirect_to(root_path)
    end
  end
end
