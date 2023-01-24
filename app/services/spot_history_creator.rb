class SpotHistoryCreator
  class << self
    def call(spot: nil, user: nil, history: nil)
      spot = spot
      user = user
      history = history

      create_spot_histories(spot, user, history)
    end

    def create_spot_histories(spot, user, history)
      spot.spot_histories.create(user_id: user.id, history: history)
    end
  end
end
