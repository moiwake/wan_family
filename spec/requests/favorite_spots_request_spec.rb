require 'rails_helper'
require 'support/shared_examples/request_spec'

RSpec.describe "FavoriteSpots", type: :request do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  before { sign_in user }

  describe "POST /create" do
    let(:new_favorite_spot) { FavoriteSpot.last }

    subject { post spot_favorite_spots_path(spot), xhr: true }

    it "お気に入りスポットの登録ができる" do
      expect { subject }.to change { FavoriteSpot.count }.by(1)
      expect(new_favorite_spot.user_id).to eq(user.id)
      expect(new_favorite_spot.spot_id).to eq(spot.id)
    end

    it_behaves_like "returns http success"
  end

  describe "DELETE /destroy" do
    let!(:favorite_spot) { create(:favorite_spot, user_id: user.id, spot_id: spot.id) }

    subject { delete spot_favorite_spot_path(spot, favorite_spot), xhr: true }

    it "お気に入りスポットの登録を削除できる" do
      expect { subject }.to change { FavoriteSpot.count }.by(-1)
    end

    it_behaves_like "returns http success"
  end
end
