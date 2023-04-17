require 'rails_helper'

RSpec.describe "SpotTags", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:spot_tag) { create(:spot_tag) }

  before { sign_in user }

  describe "GET /index" do
    subject { get spot_spot_tags_path(spot), xhr: true }

    it_behaves_like "returns http success"
  end

  describe "GET /new" do
    subject { get new_spot_spot_tag_path(spot), xhr: true }

    it_behaves_like "returns http success"
  end

  describe "POST /create" do
    subject { post spot_spot_tags_path(spot), params: { spot_tag: params }, xhr: true }

    context "パラメータの値が妥当なとき" do
      let(:params) { attributes_for(:spot_tag, user_id: user.id, spot_id: spot.id) }
      let(:new_spot_tag) { SpotTag.last }

      it "スポットにタグを登録できる" do
        expect { subject }.to change { SpotTag.count }.by(1)
        expect(new_spot_tag.user_id).to eq(user.id)
        expect(new_spot_tag.spot_id).to eq(spot.id)
      end

      it_behaves_like "returns http success"
    end

    context "パラメータの値が不正なとき" do
      let(:params) { { name: nil } }

      it "スポットにタグを登録できない" do
        expect { subject }.to change { SpotTag.count }.by(0)
      end

      it_behaves_like "returns http success"
    end
  end

  describe "GET /edit" do
    subject { get edit_spot_spot_tag_path(spot, spot_tag), xhr: true }

    it_behaves_like "returns http success"
  end

  describe "PATCH /update" do
    subject { patch spot_spot_tag_path(spot, spot_tag), params: { spot_tag: updated_params }, xhr: true }

    context "パラメータの値が妥当なとき" do
      let(:updated_params) { { name: "更新したタグ", memo: "メモを更新しました。" } }

      it "スポットのタグを更新できる" do
        expect { subject }.to change { SpotTag.count }.by(0)
        expect(spot_tag.reload.name).to eq(updated_params[:name])
        expect(spot_tag.reload.memo).to eq(updated_params[:memo])
      end

      it_behaves_like "returns http success"
    end

    context "パラメータの値が不正なとき" do
      let(:updated_params) { { name: nil } }

      before { spot_tag.reload }

      it "スポットのタグを更新できない" do
        expect { subject }.to change { SpotTag.count }.by(0)
        expect(spot_tag.saved_change_to_name?).to eq(false)
        expect(spot_tag.saved_change_to_memo?).to eq(false)
      end

      it_behaves_like "returns http success"
    end
  end

  describe "DELETE /destroy" do
    subject { delete spot_spot_tag_path(spot, spot_tag), xhr: true }

    it "スポットのタグを削除できる" do
      expect { subject }.to change { SpotTag.count }.by(-1)
    end

    it_behaves_like "returns http success"
  end
end
