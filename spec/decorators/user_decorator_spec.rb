require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  let!(:user_with_avatar) { create(:user, :updated_profile_user) }
  let!(:user_without_avatar) { create(:user) }

  describe "#display_human_avatar" do
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
end
