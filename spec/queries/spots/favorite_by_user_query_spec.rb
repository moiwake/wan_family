require 'rails_helper'

RSpec.describe Spots::FavoriteByUserQuery, type: :model do
  let!(:spots) { Spot.all }
  let(:user) { create(:user) }
  let(:class_instance) { Spots::FavoriteByUserQuery.new(user: user) }

  describe "#call" do
    subject(:return_value) { Spots::FavoriteByUserQuery.call(user: user) }

    let(:spot_favorites) { instance_double("spot") }

    before do
      allow(Spots::FavoriteByUserQuery).to receive(:new).and_return(class_instance)
      allow(class_instance).to receive(:set_spot).and_return(spot_favorites)
      subject
    end

    it "引数を渡して、Spots::FavoriteByUserQueryをレシーバーにnewメソッドを呼び出す" do
      expect(Spots::FavoriteByUserQuery).to have_received(:new).once.with(user: user)
    end

    it "Spots::FavoriteByUserQueryのインスタンスをレシーバーに、set_spotメソッドを呼び出す" do
      expect(class_instance).to have_received(:set_spot).once
    end

    it "set_spotメソッドの返り値を返す" do
      expect(return_value).to eq(spot_favorites)
    end
  end

  describe "#set_spot" do
    subject(:return_value) { class_instance.set_spot }

    let(:spot_ids) { [spots[0], spots[2], spots[1]] }
    let(:searched_spot) { spots.where(id: spot_ids).order([Arel.sql("field(spots.id, ?)"), spot_ids]) }

    before do
      allow(class_instance).to receive(:set_spot_ids).and_return(spot_ids)
      subject
    end

    it "set_spot_idsメソッドを呼び出す" do
      expect(class_instance).to have_received(:set_spot_ids).once
    end

    it "set_spot_idsメソッドの返り値と一致するidのSpotレコード群を順番通りに返す" do
      expect(return_value).to eq(searched_spot)
    end
  end

  describe "#set_spot_ids" do
    subject(:return_value) { class_instance.send(:set_spot_ids) }

    before { allow(class_instance).to receive(:set_spot_ids).and_return(spots) }

    it "order_favoritesメソッドの返り値のレコードから抽出した、spot_idの配列を返す" do
      expect(return_value).to eq(spots.ids)
    end
  end

  describe "#order_favorites" do
    subject(:return_value) { class_instance.send(:order_favorites) }

    let(:ordered_spot_favorites) { user.spot_favorites.order(created_at: :desc, id: :desc) }
    let(:another_user) { create(:user) }

    before do
      create_list(:spot_favorite, 3, user: user)
      create_list(:spot_favorite, 3, user: another_user)
    end

    it "指定のユーザーが作成したSpotFavoriteレコードを、作成日の降順に並べ替えて返す" do
      expect(return_value).to eq(ordered_spot_favorites)
    end
  end
end
