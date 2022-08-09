require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system do
  describe "ユーザーの新規登録" do
    let!(:user) { build(:user) }

    before do
      visit root_path
      click_link "新規登録"
    end

    context "入力内容が有効なとき" do
      it "新規ユーザーが登録できて、ホーム画面に戻る" do
        expect do
          fill_in "user[user_name]", with: user.user_name
          fill_in "user[email]", with: user.email
          fill_in "user[password]", with: user.password
          fill_in "user[password_confirmation]", with: user.password_confirmation
          click_button "新しいアカウントを登録する"

          expect(page).to have_content("アカウント登録が完了しました。")
        end.to change { User.count }.by(1)

        expect(current_path).to eq(root_path)
      end
    end

    context "入力内容が有効ではないとき" do
      it "新規登録できない" do
        expect do
          fill_in "user[user_name]", with: nil
          fill_in "user[email]", with: nil
          fill_in "user[password]", with: nil
          fill_in "user[password_confirmation]", with: nil
          click_button "新しいアカウントを登録する"
        end.to change { User.count }.by(0)
      end
    end

    describe "プロフィール情報の変更" do
      context "ログインユーザー" do
        it "プロフィール情報を変更できる" do
          
        end

        it "他のユーザーのプロフィール情報は変更できない" do

        end
      end

      context "ログインしていないユーザー" do
        it "プロフィール画面へのリンクが表示されない" do
          
        end
      end
    end
  end
end
