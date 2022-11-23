require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system, js: true do
  let!(:user) { create(:user) }

  describe "ユーザーの新規登録" do
    let(:new_user) { build(:user) }

    before do
      visit root_path
      click_link "新規登録"
      fill_in "user[name]", with: new_user.name
      fill_in "user[email]", with: new_user.email
      fill_in "user[password]", with: new_user.password
      fill_in "user[password_confirmation]", with: new_user.password_confirmation
    end

    it "新規ユーザーが登録できて、ホーム画面に戻る" do
      expect do
        click_button "新しいアカウントを登録する"
      end.to change { User.count }.by(1)

      expect(page).to have_content("アカウント登録が完了しました。")
      expect(current_path).to eq(root_path)
    end
  end

  describe "ユーザーのログイン" do
    before do
      visit root_path
      click_link "ログイン"
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
      click_button "ログイン"
    end

    it "ログインできて、ホーム画面に遷移する" do
      expect(current_path).to eq(root_path)
      expect(page).to have_content("ログインしました。")
    end
  end

  describe "ユーザーのログアウト" do
    before do
      sign_in user
      visit root_path
      click_button "ログアウト"
    end

    it "ログアウトできる" do
      expect(page).to have_content("ログアウトしました。")
    end
  end

  describe "マイページ" do
    let!(:user) { create(:user) }
    let(:avatar_url) do
      user.avatar.url.split('/').last
    end

    before do
      sign_in user
      visit root_path
      click_link "マイページ"
      ActiveStorage::Current.host = Capybara.app_host
    end

    describe "プロフィールの編集" do
      before do
        click_link "プロフィール編集"
        attach_file "#{Rails.root}/spec/fixtures/images/test1.png"
        fill_in "user[introduction]", with: "自己紹介を更新"
        click_button "保存"
      end

      it "自分のプロフィールは編集できる" do
        expect(page).to have_content("プロフィールを変更しました。")
        expect(user.avatar.url).to have_content(avatar_url)
        expect(user.reload.introduction).to eq("自己紹介を更新")
      end
    end

    describe "アカウント設定の変更" do
      before do
        click_link "アカウント設定"
        fill_in "user[email]", with: "updated@email.com"
        fill_in "user[password]", with: "updatedpass01"
        fill_in "user[password_confirmation]", with: "updatedpass01"
        fill_in "user[current_password]", with: user.password
        click_button "更新"
      end

      it "アカウント設定を変更でき、ホーム画面に遷移する" do
        expect(user.reload.email).to eq("updated@email.com")
        expect(user.valid_password?("updatedpass01")).to eq(true)
        expect(current_path).to eq(root_path)
        expect(page).to have_content("アカウント設定を変更しました。")
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

  describe "パスワードの再設定" do
    let(:delivered_mail) { ActionMailer::Base.deliveries.last }
    let(:password_reset_url) { URI.extract(delivered_mail.body.encoded).first }

    before do
      visit new_user_session_path
      click_link "パスワードをお忘れですか？"
      fill_in "user[email]", with: user.email
    end

    it "入力したアドレスに、再設定用のメールが送信される" do
      expect{
        click_button "パスワード再設定のメールを送信"
      }.to change { ActionMailer::Base.deliveries.size }.by(1)

      expect(page).to have_content("パスワードの再設定について数分以内にメールでご連絡いたします。")

      expect(delivered_mail.from).to eq("Wan Family")
      expect(delivered_mail.to.first).to eq(user.email)
      expect(delivered_mail.subject).to eq("パスワードの再設定について")
      expect(delivered_mail.body).to have_link("パスワードの変更", href: password_reset_url)
    end

    it "送信されたメールのリンクから、パスワードを変更できる" do
      click_button "パスワード再設定のメールを送信"
      visit password_reset_url
      fill_in "user[password]", with: "resetpass00"
      fill_in "user[password_confirmation]", with: "resetpass00"
      click_button "パスワードを変更する"

      expect(page).to have_content("パスワードが正しく変更されました。")
      expect(current_path).to eq(root_path)
      expect(user.reload.valid_password?("resetpass00")).to eq(true)
    end
  end
end
