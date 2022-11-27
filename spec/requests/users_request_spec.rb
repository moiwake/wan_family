require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, :updated_profile_user) }
  let(:avatar_url) do
    user.avatar.url.split('/').last
  end

  describe "GET /index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_path
        ActiveStorage::Current.host = "http://www.example.com"
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "ログインユーザーのデータが表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
      end
    end

    context "ログインしていないとき" do
      before do
        get users_mypage_path
      end

      it "ログイン画面にリダイレクトされる" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_edit_profile_path
        ActiveStorage::Current.host = "http://www.example.com"
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "ログインユーザーデータが表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
        expect(response.body).to include(user.introduction)
      end
    end

    context "ログインしていないとき" do
      before do
        get users_edit_profile_path
      end

      it "ログイン画面にリダイレクトされる" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /update" do
    let(:updated_attributes) { { introduction: "更新しました。", avatar: updated_avatar } }
    let(:updated_avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test2.png'), 'image/png') }
    let(:updated_avatar_url) { user.avatar.url.split('/').last }

    subject {
      patch users_profile_path, params: { user: updated_attributes }
      ActiveStorage::Current.host = "http://www.example.com"
    }

    before do
      sign_in user
    end

    it "HTTPリクエストが成功する" do
      subject
      expect(response).to have_http_status(302)
    end

    it "ログインユーザーのレコードを更新できる" do
      expect do
        subject
      end.to change { User.count }.by(0)

      expect(user.introduction).to eq(updated_attributes[:introduction])
      expect(user.avatar.url).to include(updated_avatar_url)
    end

    it "更新後にリダイレクトする" do
      subject
      expect(response).to redirect_to(users_edit_profile_path)
    end
  end
end
