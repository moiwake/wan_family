module Spots
  class FavoriteByUserQuery
    attr_reader :spot, :user

    def initialize(spot: Spot.all, user:)
      @spot = spot
      @user = user
    end

    def self.call(user:)
      @spot = new(user: user).set_spot
      return @spot
    end

    def set_spot
      spot_ids = set_spot_ids
      spot.where(id: spot_ids).order([Arel.sql("field(spots.id, ?)"), spot_ids])
    end

    private

    def set_spot_ids
      order_favorites.pluck(:spot_id)
    end

    def order_favorites
      favorites_created_by_user.order(created_at: :desc, id: :desc)
    end

    def favorites_created_by_user
      user.favorite_spots
    end
  end
end
