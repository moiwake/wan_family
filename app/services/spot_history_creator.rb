class SpotHistoryCreator
  attr_accessor :spot, :user, :history

  def self.call(spot: nil, user: nil, history: nil)
    new(spot: spot, user: user, history: history).create_spot_histories
  end

  def initialize(spot: nil, user: nil, history: nil)
    @spot = spot
    @user = user
    @history = history
  end

  def create_spot_histories
    spot.spot_histories.create(user_id: user.id, history: history)
  end
end
