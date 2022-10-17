require 'rails_helper'

RSpec.describe "AdminsSystemSpecs", type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe "管理者のログイン" do
    before do
      visit new_admin_session_path
    end

    it "ログイン情報が正しければ、ログインできて、サイト管理ページのトップに遷移する。", js: true do
      fill_in "admin[email]", with: admin.email
      fill_in "admin[password]", with: admin.password
      click_button "ログイン"
      expect(current_path).to eq(rails_admin_path)
      expect(page).to have_content("ログインしました。")
    end

    it "ログイン情報が間違っているとログインできない", js: true do
      fill_in "admin[email]", with: "incorrect_email"
      fill_in "admin[password]", with: "incorrect_password"
      click_button "ログイン"
      expect(page).to have_content("ログインに失敗しました。メールアドレスまたはパスワードが違います。")
    end
  end

  describe "トップページの表示" do
    context "管理者がログインしているとき" do
      before do
        sign_in admin
        visit root_path
      end

      it "管理者に権限があるページのリンクのみ表示される" do
        expect(page).to have_link("サイト管理ページへ", href: rails_admin_path)
        expect(page).not_to have_link("マイページ", href: mypage_path)
      end

      it "管理者が利用しないページのリンクは表示されない" do
        expect(page).not_to have_link("新規登録", href: new_user_registration_path)
        expect(page).not_to have_link("ログイン", href: new_user_session_path)
        expect(page).not_to have_button("ログアウト")
      end
    end
  end

  describe "サイト管理ページへのアクセス" do
    context "管理者以外がアクセスしたとき" do
      it "管理者用のログインページへリダイレクトされる" do
        sign_in user
        visit rails_admin_path
        expect(current_path).to eq(new_admin_session_path)
      end
    end

    context "ログインせずにアクセスしたとき" do
      it "管理者用のログインページへリダイレクトされる" do
        visit rails_admin_path
        expect(current_path).to eq(new_admin_session_path)
      end
    end
  end
end
