require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "SpotFavorites", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  before { sign_in user }

  describe "POST /create" do
    let(:new_spot_favorite) { SpotFavorite.last }

    subject { post spot_spot_favorites_path(spot), xhr: true }

    it "お気に入りスポットの登録ができる" do
      expect { subject }.to change { SpotFavorite.count }.by(1)
      expect(new_spot_favorite.user_id).to eq(user.id)
      expect(new_spot_favorite.spot_id).to eq(spot.id)
    end

    it_behaves_like "returns http success"
  end

  describe "DELETE /destroy" do
    let!(:spot_favorite) { create(:spot_favorite, user_id: user.id, spot_id: spot.id) }

    subject { delete spot_spot_favorite_path(spot, spot_favorite), xhr: true }

    it "お気に入りスポットの登録を削除できる" do
      expect { subject }.to change { SpotFavorite.count }.by(-1)
    end

    it_behaves_like "returns http success"
  end
end
