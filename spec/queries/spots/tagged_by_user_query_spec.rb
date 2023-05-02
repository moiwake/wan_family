require 'rails_helper'

RSpec.describe Spots::TaggedByUserQuery, type: :model do
  let!(:spots) { Spot.all }
  let(:class_instance) { Spots::TaggedByUserQuery.new(arguments) }
  let(:arguments) { { user: user, tag_params: tag_params } }
  let(:user) { create(:user) }
  let(:tag_params) { {} }

  describe "#call" do
    subject(:return_value) { Spots::TaggedByUserQuery.call(arguments) }

    let(:spot_tags) { instance_double("spot") }

    before do
      allow(Spots::TaggedByUserQuery).to receive(:new).and_return(class_instance)
      allow(class_instance).to receive(:set_spot).and_return(spot_tags)
      subject
    end

    it "引数を渡して、Spots::FavoriteByUserQueryをレシーバーにnewメソッドを呼び出す" do
      expect(Spots::TaggedByUserQuery).to have_received(:new).once.with(arguments)
    end

    it "Spots::FavoriteByUserQueryのインスタンスをレシーバーに、set_spotメソッドを呼び出す" do
      expect(class_instance).to have_received(:set_spot).once
    end

    it "set_spotメソッドの返り値を返す" do
      expect(return_value).to eq(spot_tags)
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

    it "order_tagsメソッドの返り値のレコードから抽出した、spot_idの配列を返す" do
      expect(return_value).to eq(spots.ids)
    end
  end

  describe "#order_tags" do
    subject(:return_value) { class_instance.send(:order_tags) }

    let(:another_user) { create(:user) }

    before do
      create_list(:spot_tag, 2, user: user, name: "tag_name1")
      create(:spot_tag, user: user, name: "tag_name2")
      create_list(:spot_tag, 3, user: another_user)
    end

    context "tag_paramsのハッシュに、tag_nameキーの値が存在するとき" do
      let(:ordered_spot_tags) { user.spot_tags.where(name: "tag_name1").order(created_at: :desc) }
      let(:tag_params) { { tag_name: "tag_name1" } }

      it "指定のユーザーが作成したSpotTagレコードのうち、nameカラムがtag_nameキーの値と一致するレコードを、作成日の降順に並べ替えて返す" do
        expect(return_value).to eq(ordered_spot_tags)
      end
    end

    context "tag_paramsのハッシュに、tag_nameキーの値が存在しないとき" do
      let(:ordered_spot_tags) { user.spot_tags.order(created_at: :desc) }
      let(:tag_params) { { tag_name: "" } }

      it "指定のユーザーが作成したSpotTagレコードを、作成日の降順に並べ替えて返す" do
        expect(return_value).to eq(ordered_spot_tags)
      end
    end
  end
end
