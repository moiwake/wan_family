require 'rails_helper'

RSpec.describe SpotHistoryCreator, type: :model do
  let!(:spot) { create(:spot) }
  let!(:user) { instance_double(User, id: 1) }
  let!(:spot_history_creator_instance) { SpotHistoryCreator.new(spot: spot, user: user, history: "履歴") }

  describe "#call" do
    before do
      allow(SpotHistoryCreator).to receive(:new).and_return(spot_history_creator_instance)
      allow(spot_history_creator_instance).to receive(:create_spot_histories)
      SpotHistoryCreator.call(spot: spot, user: user, history: "履歴")
    end

    it "引数の値を渡してnewメソッドを呼び出す" do
      expect(SpotHistoryCreator).to have_received(:new).once.with({ spot: spot, user: user, history: "履歴" })
    end

    it "SpotHistoryCreatorのインスタンスに対して、create_spot_historiesメソッドを呼び出す" do
      expect(spot_history_creator_instance).to have_received(:create_spot_histories).once
    end
  end

  describe "#create_spot_histories" do
    let(:spot_history) { spot_history_creator_instance.create_spot_histories }

    it "あるスポットに紐付いた登録履歴のレコードを作成、保存する" do
      expect(spot_history.spot_id).to eq(spot.id)
      expect(spot_history.user_id).to eq(user.id)
      expect(spot_history.history).to eq("履歴")
    end
  end
end
