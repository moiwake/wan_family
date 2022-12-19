require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user, :updated_profile_user) }

  describe "GET /index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get mypage_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get mypage_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /spot_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_spot_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_spot_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /review_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_review_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_review_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /image_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_image_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_image_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get edit_profile_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get edit_profile_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "PATCH /update" do
    let(:updated_params) { { introduction: "updated introduction", avatar: updated_avatar } }
    let(:updated_avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test2.png'), 'image/png') }
    let(:updated_avatar_filename) { updated_avatar.original_filename }

    subject { patch profile_path, params: { user: updated_params } }

    before { sign_in user }

    it "ログインユーザーのレコードを更新できる" do
      expect { subject }.to change { User.count }.by(0)
      expect(user.introduction).to eq(updated_params[:introduction])
      expect(user.avatar.filename.to_s).to eq(updated_avatar_filename)
    end

    it "更新後にリダイレクトする" do
      subject
      expect(response).to redirect_to(edit_profile_path)
    end
  end
end
