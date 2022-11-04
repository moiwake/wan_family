class SpotHistoryCreator
  attr_accessor :spot, :user

  def self.call(spot: nil, user: nil)
    new(spot: spot, user: user).call_create_spot_histories
  end

  def initialize(spot: nil, user: nil)
    @spot = spot
    @user = user
  end

  def call_create_spot_histories
    if spot.new_record?
      create_spot_histories("新規登録")
    elsif spot.persisted?
      create_spot_histories("更新")
    end
  end

  private

  def create_spot_histories(history)
    spot.spot_histories.create(user_id: user.id, history: history)
  end
end
