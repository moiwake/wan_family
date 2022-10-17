require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user, :updated_profile_user) }
  let(:avatar_url) do
    user.avatar.url.split('/').last
  end

  describe "GET /index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get mypage_path
        ActiveStorage::Current.host = "http://www.example.com"
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "ユーザー情報が表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
      end
    end

    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトされる" do
        get mypage_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get edit_profile_path
        ActiveStorage::Current.host = "http://www.example.com"
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(:success)
      end

      it "ユーザー情報が表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
        expect(response.body).to include(user.introduction)
      end
    end

    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトされる" do
        get edit_profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /update" do
    before do
      sign_in user
    end

    context "ログインしているとき" do
      let(:update_attributes) do
        {
          introduction: "更新しました。",
          avatar: update_avatar,
        }
      end
      let(:update_avatar) do
        fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test.jpeg'), 'image/jpeg')
      end
      let(:update_avatar_url) do
        user.avatar.url.split('/').last
      end

      it "usersテーブルのintroductionカラム、avatarカラムを更新できる" do
        patch profile_path, params: { user: update_attributes }
        ActiveStorage::Current.host = "http://www.example.com"

        expect do
          expect(user.introduction).to eq(update_attributes[:introduction])
          expect(user.avatar.url).to include(update_avatar_url)
        end.to change { User.count }.by(0)
      end

      it "更新後にリダイレクトする" do
        patch profile_path, params: { user: update_attributes }
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end
end
