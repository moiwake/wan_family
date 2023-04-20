require 'rails_helper'

RSpec.describe "AdminsSystemSpecs", type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe "管理者のログイン" do
    before { visit new_admin_session_path }

    it "入力データが正しければ、ログインできて、サイト管理ページのトップに遷移する。" do
      fill_in "admin_email", with: admin.email
      fill_in "admin_password", with: admin.password
      click_button "ログイン"
      expect(current_path).to eq(rails_admin_path)
      expect(page).to have_content("ログインしました。")
    end

    it "入力データが間違っているとログインできない" do
      fill_in "admin_email", with: "incorrect_email"
      fill_in "admin_password", with: "incorrect_password"
      click_button "ログイン"
      expect(page).to have_content("ログインに失敗しました。メールアドレスまたはパスワードが違います。")
    end

    it "トップページへのリンクが表示される" do
      expect(find(".page-link-wrap")).to have_link("TOP", href: root_path)
    end
  end

  describe "サイト管理ページへのアクセス" do
    context "管理者以外がアクセスしたとき" do
      before do
        sign_in user
        visit rails_admin_path
      end

      it "管理者用のログインページへリダイレクトされる" do
        expect(current_path).to eq(new_admin_session_path)
      end
    end

    context "ログインせずにアクセスしたとき" do
      before { visit rails_admin_path }

      it "管理者用のログインページへリダイレクトされる" do
        expect(current_path).to eq(new_admin_session_path)
      end
    end
  end
end
