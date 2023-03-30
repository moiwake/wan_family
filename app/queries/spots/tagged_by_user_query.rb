module Spots
  class TaggedByUserQuery
    attr_reader :spot, :user, :tag_params

    def initialize(spot: Spot.all, user:, tag_params:)
      @spot = spot
      @user = user
      @tag_params = tag_params
    end

    def self.call(user:, tag_params: {})
      @spot = new(user: user, tag_params: tag_params).set_spot
      return @spot
    end

    def set_spot
      spot_ids = set_spot_ids
      spot.where(id: spot_ids).order([Arel.sql("field(spots.id, ?)"), spot_ids])
    end

    private

    def set_spot_ids
      order_tags.pluck(:spot_id)
    end

    def order_tags
      tags_created_by_user.order(created_at: :desc)
    end

    def tags_created_by_user
      spot_tags = user.spot_tags

      if tag_params[:tag_name].present?
        spot_tags = spot_tags.where(name: tag_params[:tag_name])
      end

      return spot_tags
    end
  end
end
