require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  describe "#display_human_avatar" do
    let!(:user_with_avatar) { create(:user, :updated_profile_user) }
    let!(:user_without_avatar) { create(:user) }

    context "ユーザー画像が登録されているとき" do
      it "登録されたユーザー画像が表示される" do
        expect(user_with_avatar.decorate.display_human_avatar).to eq(user_with_avatar.human_avatar)
      end
    end

    context "ユーザー画像が登録されていないとき" do
      it "未登録用の画像が表示される" do
        expect(user_without_avatar.decorate.display_human_avatar).to eq("noavatar-human.png")
      end
    end
  end

  describe "#display_dog_avatar" do
    let!(:user_with_avatar) { create(:user, :updated_profile_user) }
    let!(:user_without_avatar) { create(:user) }

    context "ユーザー画像が登録されているとき" do
      it "登録されたユーザー画像が表示される" do
        expect(user_with_avatar.decorate.display_dog_avatar).to eq(user_with_avatar.dog_avatar)
      end
    end

    context "ユーザー画像が登録されていないとき" do
      it "未登録用の画像が表示される" do
        expect(user_without_avatar.decorate.display_dog_avatar).to eq("noavatar-dog.png")
      end
    end
  end

  describe "#total_of_images_posted_by_user" do
    let!(:user) { create(:user) }

    before { create(:image, :attached, user: user) }

    it "レシーバーのユーザーが登録したImageレコードに紐づくBlobレコードの数を返す" do
      expect(user.decorate.total_of_images_posted_by_user).to eq(2)
    end
  end
end
