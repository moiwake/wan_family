class SpotsForRankQuery < ForRankQueryBase
  def initialize(scope:, rank_class:)
    super(scope: scope, rank_class: rank_class)
  end

  def self.call(scope: Spot.all, rank_class: "FavoriteSpot")
    super
  end
end
