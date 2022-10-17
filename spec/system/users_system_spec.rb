require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system do
  let!(:user) { create(:user) }

  describe "ユーザーの新規登録" do
    let(:new_user) { build(:user) }

    before do |example|
      unless example.metadata[:skip_before]
        visit root_path
        click_link "新規登録"
      end
    end

    context "入力内容が有効なとき" do
      it "新規ユーザーが登録できて、ホーム画面に戻る", js: true do
        expect do
          fill_in "user[name]", with: new_user.name
          fill_in "user[email]", with: new_user.email
          fill_in "user[password]", with: new_user.password
          fill_in "user[password_confirmation]", with: new_user.password_confirmation
          click_button "新しいアカウントを登録する"
          expect(page).to have_content("アカウント登録が完了しました。")
        end.to change { User.count }.by(1)

        expect(current_path).to eq(root_path)
      end
    end

    context "入力内容が有効ではないとき" do
      it "新規登録できない", js: true do
        expect do
          fill_in "user[name]", with: nil
          fill_in "user[email]", with: nil
          fill_in "user[password]", with: nil
          fill_in "user[password_confirmation]", with: nil
          click_button "新しいアカウントを登録する"
        end.to change { User.count }.by(0)
      end
    end

    context "すでにログインしているとき" do
      it "新規登録ページへアクセスすると、ホーム画面へリダイレクトする", :skip_before do
        sign_in user
        visit new_user_registration_path
        expect(current_path).to eq(root_path)
        expect(page).to have_content("すでにログインしています。")
      end
    end
  end

  describe "ユーザーのログイン・ログアウト" do
    before do |example|
      unless example.metadata[:skip_before]
        visit root_path
        click_link "ログイン"
      end
    end

    context "ログイン情報が正しいとき" do
      it "ログインできて、ホーム画面に遷移する", js: true do
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "ログイン"
        expect(current_path).to eq(root_path)
        expect(page).to have_content("ログインしました。")
      end
    end

    context "ログイン情報が間違っているとき" do
      it "ログインできない", js: true do
        fill_in "user[email]", with: "incorrect_email"
        fill_in "user[password]", with: "incorrect_password"
        click_button "ログイン"
        expect(page).to have_content("ログインに失敗しました。メールアドレスまたはパスワードが違います。")
      end
    end

    context "すでにログインしているとき" do
      it "ログインページへアクセスすると、ホーム画面にリダイレクトする", :skip_before do
        sign_in user
        visit new_user_session_path
        expect(current_path).to eq(root_path)
        expect(page).to have_content("すでにログインしています。")
      end
    end

    it "ログアウトできる", :skip_before do
      sign_in user
      visit root_path
      click_button "ログアウト"
      expect(page).to have_content("ログアウトしました。")
    end
  end

  describe "マイページ" do
    context "ログインユーザー" do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:another_user) }
      let(:avatar_url) do
        user.avatar.url.split('/').last
      end

      before do
        sign_in user
        visit root_path
        click_link "マイページ"
        ActiveStorage::Current.host = Capybara.app_host
      end

      describe "マイページの表示" do
        context "ユーザー画像が登録されていないとき" do
          it "未登録用の画像が表示される" do
            expect(page).to have_selector("img[src*='noavatar']")
          end
        end
      end

      describe "プロフィール編集ページの表示" do
        context "ユーザー画像が登録されていないとき" do
          it "未登録用の画像が表示される" do
            expect(page).to have_selector("img[src*='noavatar']")
          end
        end
      end

      describe "プロフィールの編集", js: true do
        before do
          click_link "プロフィール編集"
          attach_file "#{Rails.root}/spec/fixtures/images/test.jpeg"
          fill_in "user[introduction]", with: "自己紹介を更新"
          click_button "保存"
        end

        it "自分のプロフィールは編集できる" do
          expect(page).to have_content("プロフィールを変更しました。")
          expect(user.avatar.url).to have_content(avatar_url)
          expect(user.reload.introduction).to eq("自己紹介を更新")
        end

        it "他のユーザーのプロフィールは編集できない" do
          expect(another_user.avatar.attached?).to be(false)
          expect(another_user.reload.introduction).to eq("更新されてません")
        end
      end

      describe "アカウント設定の変更", js: true do
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
            expect(user.reload.email).not_to eq("updated@email.com")
            expect(user.valid_password?("updatedpass01")).to eq(false)
          end
        end
      end

      describe "アカウントの削除", js: true do
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
      it "マイページのリンクが表示されない" do
        visit root_path
        expect(page).not_to have_link("マイページ", href: mypage_path)
      end
    end
  end

  describe "トップページの表示" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in user
        visit root_path
      end

      it "ユーザーに権限があるページのリンクのみ表示される" do
        expect(page).to have_link("マイページ", href: mypage_path)
        expect(page).to have_button("ログアウト")
        expect(page).not_to have_link("サイト管理ページへ", href: rails_admin_path)
      end

      it "新規登録とログインのリンクは表示されない" do
        expect(page).not_to have_link("新規登録", href: new_user_registration_path)
        expect(page).not_to have_link("ログイン", href: new_user_session_path)
      end
    end
  end
end
