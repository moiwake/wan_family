class SpotHistoryCreator
  attr_reader :spot, :user, :history

  def initialize(spot:, user:, history:)
    @spot = spot
    @user = user
    @history = history
  end

  def self.call(spot: nil, user: nil, history: nil)
    new(spot: spot, user: user, history: history).create_spot_histories
  end

  def create_spot_histories
    spot.spot_histories.create(user_id: user.id, history: history)
  end
end
