require 'rails_helper'

RSpec.describe "UsersSystemSpecs", type: :system do
  let!(:user) { create(:user) }

  describe "マイページ" do
    before do
      sign_in user
      visit mypage_path
    end

    it "ユーザーのデータが表示される" do
      expect(page).to have_content(user.name)
    end

    it "プロフィール編集ページヘのリンクがある" do
      expect(page).to have_link("プロフィール編集", href: edit_profile_path)
    end

    it "アカウント設定ページヘのリンクがある" do
      expect(page).to have_link("アカウント設定", href: edit_user_registration_path)
    end

    it "登録スポット一覧ページヘのリンクがある" do
      expect(page).to have_link("登録したスポット", href: users_spot_index_path)
    end

    it "投稿レビュー一覧ページヘのリンクがある" do
      expect(page).to have_link("投稿したレビュー", href: users_review_index_path)
    end

    it "投稿画像一覧ページヘのリンクがある" do
      expect(page).to have_link("投稿した画像", href: users_image_index_path)
    end

    context "ユーザー画像を登録しているとき" do
      let!(:user) { create(:user, :updated_profile_user) }
      let!(:human_avatar_filename) { user.human_avatar.filename.to_s }

      it "ユーザー画像が表示される" do
        expect(find("img")[:src]).to include(human_avatar_filename)
      end
    end

    context "ユーザー画像を登録していないとき" do
      it "未登録用の画像が表示される" do
        expect(find("img")[:src]).to include("nohuman_avatar")
      end
    end
  end

  describe "登録スポット一覧ページ" do
    let(:spot_histories) { create_list(:spot_history, 3, user_id: user.id) }
    let!(:spots) { spot_histories.map { |spot_history| spot_history.spot } }

    before do
      sign_in user
      visit users_spot_index_path
    end

    it "ユーザーが登録したすべてのスポットのデータが表示される" do
      spots.each do |spot|
        expect(page).to have_link(spot.name, href: spot_path(spot))
        expect(page).to have_content(spot.address)
        expect(page).to have_content(Category.find(spot.category_id).name)
      end
    end

    it "マイページへのリンクがある" do
      expect(page).to have_link("マイページへ戻る", href: mypage_path)
    end
  end

  describe "投稿レビュー一覧ページ" do
    let!(:spot) { create(:spot) }
    let!(:reviews) { create_list(:review, 3, :with_image, user_id: user.id, spot_id: spot.id) }
    let(:images_filenames) { reviews[0].image.files.map { |file| file.filename.to_s } }
    let(:removed_review) { reviews[0] }

    before do
      sign_in user
      visit users_review_index_path
    end

    it "ユーザーが投稿したすべてのレビューのデータが表示される", js: true do
      reviews.each do |review|
        expect(page).to have_link(spot.name, href: spot_path(spot))
        expect(page).to have_link(review.title, href: spot_review_path(spot, review))
        expect(page).to have_content(review.comment)

        within("#dog-ratings#{review.id}") do
          expect(page.all(".colored").length).to eq(review.dog_score)
        end

        within("#human-ratings#{review.id}") do
          expect(page.all(".colored").length).to eq(review.human_score)
        end
      end
    end

    it "レビューに紐づく画像が、上限枚数以下で表示される" do
      reviews.each_with_index do |review, i|
        within(page.all(".review-grid-list")[i]) do
          review.image.files.length.times do |t|
            break if t == Image::MAX_DISPLAY_NUMBER
            expect(page.all("img")[t][:src]).to include(images_filenames[t])
          end

          expect(page.all("img").length).to be<=(Image::MAX_DISPLAY_NUMBER)
        end
      end
    end

    it "レビュー編集ページへの個別リンクがある" do
      reviews.each_with_index do |review, i|
        expect(page).to have_link(href: edit_spot_review_path(spot, review))
      end
    end

    it "レビューを個別削除できる", js: true do
      expect do
        page.all("i.fa-trash")[0].click
        expect(page.accept_confirm).to eq("#{spot.name}のレビュー「#{removed_review.title}」を削除しますか？")
        expect(page).to have_content("#{spot.name}のレビュー「#{removed_review.title}」を削除しました。")
      end.to change {Review.count}.by(-1)

      expect(Review.all.pluck(:id).include?(removed_review.id)).to eq(false)
    end

    it "マイページへのリンクがある" do
      expect(page).to have_link("マイページへ戻る", href: mypage_path)
    end
  end

  describe "投稿画像一覧ページ" do
    let!(:images) { [image_1, image_2, image_3] }
    let!(:image_1) { create(:image, :attached, user_id: user.id) }
    let!(:image_2) { create(:image, :attached_1, user_id: user.id) }
    let!(:image_3) { create(:image, :attached_2, user_id: user.id) }
    let!(:images_filenames) do
      images.map do |image|
        image.files.map { |file| file.filename.to_s }
      end.flatten
    end

    before do
      sign_in user
      visit users_image_index_path
    end

    it "ユーザーが投稿したすべての画像が表示される" do
      images.each_with_index do |image, i|
        expect(page.all("img")[i][:src]).to include(images_filenames[i])
      end
    end

    it "マイページへのリンクがある" do
      expect(page).to have_link("マイページへ戻る", href: mypage_path)
    end
  end

  describe "プロフィール編集ページ" do
    before do
      sign_in user
      visit mypage_path
      click_link "プロフィール編集"
    end

    describe "プロフィールの表示" do
      it "ユーザーのデータが表示される" do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.introduction)
      end

      it "マイページへのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: mypage_path)
      end

      context "ユーザー画像を登録しているとき" do
        let!(:user) { create(:user, :updated_profile_user) }
        let!(:human_avatar_filename) { user.human_avatar.filename.to_s }

        it "ユーザー画像が表示される" do
          expect(find("img")[:src]).to include(human_avatar_filename)
        end
      end

      context "ユーザー画像を登録していないとき" do
        it "未登録用の画像が表示される" do
          expect(find("img")[:src]).to include("nohuman_avatar")
        end
      end
    end

    describe "プロフィールの編集", js: true do
      let!(:human_avatar_filename) { user.human_avatar.filename.to_s }

      before do
        attach_file "#{Rails.root}/spec/fixtures/images/test1.png"
        fill_in "user[introduction]", with: "updated introduction"
        click_button "保存"
      end

      it "プロフィールを編集できる" do
        expect(page).to have_content("プロフィールを変更しました。")
        expect(user.reload.introduction).to eq("updated introduction")
        expect(find("img")[:src]).to include(human_avatar_filename)
      end
    end
  end

  describe "アカウント設定ページ" do
    before do
      sign_in user
      visit mypage_path
      click_link "アカウント設定"
    end

    describe "アカウント情報の表示" do
      it "マイページへのリンクがある" do
        expect(page).to have_link("マイページへ戻る", href: mypage_path)
      end
    end

    describe "アカウント設定の変更", js: true do
      let(:updated_user) { build(:user) }

      before do
        fill_in "user[email]", with: updated_user.email
        fill_in "user[password]", with: updated_user.password
        fill_in "user[password_confirmation]", with: updated_user.password_confirmation
        fill_in "user[current_password]", with: user.password
        click_button "更新"
      end

      it "アカウント設定を変更でき、ホーム画面に遷移する" do
        expect(user.reload.email).to eq(updated_user.email)
        expect(user.valid_password?(updated_user.password)).to eq(true)
        expect(current_path).to eq(root_path)
        expect(page).to have_content("アカウント設定を変更しました。")
      end
    end

    describe "アカウントの削除", js: true do
      before { click_button "アカウントの削除" }

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

  describe "ユーザーの新規登録", js: true do
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

  describe "ログイン" do
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

  describe "ログアウト" do
    before do
      sign_in user
      visit root_path
      click_link "ログアウト"
    end

    it "ログアウトできる" do
      expect(page).to have_content("ログアウトしました。")
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
