require 'rails_helper'

RSpec.describe "FavoriteSpots", type: :request do
  describe "GET /create_and_destroy" do
    it "returns http success" do
      get "/favorite_spots/create_and_destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
