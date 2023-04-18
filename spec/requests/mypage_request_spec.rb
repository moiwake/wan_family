require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "Mypage", type: :request do
  let!(:user) { create(:user, :updated_profile_user) }

  describe "GET /favorite_spot_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_favorite_spot_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_favorite_spot_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /spot_tag_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_spot_tag_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_spot_tag_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /spot_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_spot_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_spot_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /review_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_review_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_review_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /image_index" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_image_index_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_image_index_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "GET /edit" do
    context "ログインしているとき" do
      before do
        sign_in user
        get users_mypage_profile_edit_path
      end

      it_behaves_like "returns http success"
    end

    context "ログインしていないとき" do
      before { get users_mypage_profile_edit_path }

      it_behaves_like "redirects to login page"
    end
  end

  describe "PATCH /update" do
    let(:updated_params) { { introduction: "updated introduction", human_avatar: updated_human_avatar, dog_avatar: updated_dog_avatar } }
    let(:updated_human_avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test3.png'), 'image/png') }
    let(:updated_dog_avatar) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'test4.png'), 'image/png') }
    let(:updated_human_avatar_filename) { updated_human_avatar.original_filename }
    let(:updated_dog_avatar_filename) { updated_dog_avatar.original_filename }

    subject { patch users_mypage_profile_path, params: { user: updated_params } }

    before { sign_in user }

    it "ログインユーザーのUserレコードを更新できる" do
      expect { subject }.to change { User.count }.by(0)
      expect(user.introduction).to eq(updated_params[:introduction])
      expect(user.human_avatar.filename.to_s).to eq(updated_human_avatar_filename)
      expect(user.dog_avatar.filename.to_s).to eq(updated_dog_avatar_filename)
    end

    it "更新後にリダイレクトする" do
      subject
      expect(response).to redirect_to(users_mypage_favorite_spot_index_path)
    end
  end
end
