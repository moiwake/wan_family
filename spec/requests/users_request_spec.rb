require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user, :updated_profile_user) }
  let!(:another_user) { create(:user, :updated_profile_user, introduction: "another_introduction") }
  let(:avatar_url) do
    user.avatar.url.split('/').last
  end
  let(:another_avatar_url) do
    another_user.avatar.attach(io: File.open('spec/fixtures/images/test2.png'), filename: 'test2.jpeg', content_type: 'image/png')
    another_user.avatar.url.split('/').last
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

      it "ログインユーザーデータが表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
      end

      it "ログインユーザー以外のデータは表示されない" do
        expect(response.body).not_to include(another_user.name)
        expect(response.body).not_to include(another_avatar_url)
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

      it "ログインユーザーデータが表示される" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(avatar_url)
        expect(response.body).to include(user.introduction)
      end

      it "ログインユーザー以外のデータは表示されない" do
        expect(response.body).not_to include(another_user.name)
        expect(response.body).not_to include(another_avatar_url)
        expect(response.body).not_to include(another_user.introduction)
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
    context "ログインしているとき" do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:update_attributes) do
        {
          introduction: "更新しました。",
          avatar: update_avatar,
        }
      end
      let(:update_avatar) do
        fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test1.png'), 'image/png')
      end
      let(:update_avatar_url) do
        user.avatar.url.split('/').last
      end

      before do
        sign_in user
        patch profile_path, params: { user: update_attributes }
        ActiveStorage::Current.host = "http://www.example.com"
      end

      it "ログインユーザーのintroductionカラム、avatarカラムを更新できる" do
        expect do
          expect(user.introduction).to eq(update_attributes[:introduction])
          expect(user.avatar.url).to include(update_avatar_url)
        end.to change { User.count }.by(0)
      end

      it "ログインユーザー以外のintroductionカラム、avatarカラムは更新されない" do
        expect do
          expect(another_user.introduction).not_to eq(update_attributes[:introduction])
          expect(another_user.avatar.url).to eq(nil)
        end.to change { User.count }.by(0)
      end

      it "更新に成功すればリダイレクトする" do
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end
end
