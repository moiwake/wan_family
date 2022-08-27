require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system, js: true do
  describe "ユーザーの新規登録" do
    let(:user) { build(:user) }

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
  end

  context "ログインユーザー" do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:another_user) }
    let(:avatar_url) do
      user.avatar.url.split('/').last
    end

    before do
      sign_in user
      visit root_path
      click_link "会員情報"
      ActiveStorage::Current.host = Capybara.app_host
    end

    describe "プロフィールの編集" do
      before do
        click_link "プロフィール編集"
        attach_file "#{Rails.root}/spec/fixtures/images/test.jpeg"
        fill_in "user[user_introduction]", with: "自己紹介を更新"
        click_button "保存"
      end

      it "自分のプロフィールは編集できる" do
        expect(page).to have_content("プロフィールを変更しました。")
        expect(user.avatar.url).to have_content(avatar_url)
        expect(user.reload.user_introduction).to eq("自己紹介を更新")
      end

      it "他のユーザーのプロフィールは編集できない" do
        expect(another_user.avatar.attached?).to be(false)
        expect(another_user.reload.user_introduction).to eq("更新されてません")
      end
    end

    describe "アカウント設定の変更" do
      before do
        click_link "アカウント設定"
        fill_in "user[email]", with: "updated@email.com"
        fill_in "user[password]", with: "updatedpass01"
        fill_in "user[password_confirmation]", with: "updatedpass01"
      end

      context "現在のパスワードの入力が正しいとき" do
        before do
          fill_in "user[current_password]", with: user.password
          click_button "更新"
        end

        it "自分のアカウント設定を変更でき、ホーム画面に遷移する" do
          expect(user.reload.email).to eq("updated@email.com")
          expect(user.valid_password?("updatedpass01")).to eq(true)
          expect(current_path).to eq(root_path)
          expect(page).to have_content("アカウント情報を変更しました。")
        end

        it "他のユーザーのアカウント設定は変更できない" do
          expect(another_user.reload.email).to eq("another@email.com")
          expect(another_user.reload.password).to eq("anotherpass01")
        end
      end

      context "現在のパスワードの入力が間違っているとき" do
        it "アカウント設定を変更できない" do
          fill_in "user[current_password]", with: "incorrect_pass"
          click_button "更新"

          expect(user.reload.email).to eq("user01@email.com")
          expect(user.valid_password?("updatedpass01")).to eq(false)
        end
      end
    end

    describe "アカウントの削除" do
      before do
        click_link "アカウント設定"
        click_button "アカウントの削除"
      end

      context "confirmダイアログでOKをクリックすると" do
        it "アカウントを削除できて、ホーム画面に遷移する" do
          expect do
            expect(page.accept_confirm).to eq("本当に削除しますか？")
            expect(current_path).to eq(root_path)
            expect(page).to have_content("アカウントを削除しました。またのご利用をお待ちしております。")
          end.to change { User.count }.by(-1)
        end
      end

      context "confirmダイアログでキャンセルをクリックすると" do
        it "アカウントは削除されない" do
          expect do
            expect(page.dismiss_confirm).to eq("本当に削除しますか？")
          end.to change { User.count }.by(0)
        end
      end
    end
  end

  context "ログインしていないユーザー" do
    it "会員情報のリンクが表示されない" do
      visit root_path
      expect(page).not_to have_link("会員情報", href: mypage_path)
    end
  end
end
