require 'rails_helper'

RSpec.describe Spots::TaggedByUserQuery, type: :model do
  let(:spots) { Spot.all }
  let(:user) { create(:user) }
  let(:tag_params) { {} }
  let(:class_instance) { Spots::TaggedByUserQuery.new(user: user, tag_params: tag_params) }

  describe "#call" do
    subject(:return_value) { Spots::TaggedByUserQuery.call(user: user, tag_params: tag_params) }

    let(:spot_tags) { instance_double("spot") }

    before do
      allow(Spots::TaggedByUserQuery).to receive(:new).and_return(class_instance)
      allow(class_instance).to receive(:set_spot).and_return(spot_tags)
      subject
    end

    it "引数を渡して、Spots::FavoriteByUserQueryをレシーバーにnewメソッドを呼び出す" do
      expect(Spots::TaggedByUserQuery).to have_received(:new).once.with(user: user, tag_params: tag_params)
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

    let(:spot_ids) { [spots[0].id, spots[2].id, spots[1].id] }

    before do
      create_list(:spot, 3)
      allow(class_instance).to receive(:set_spot_ids).and_return(spot_ids)
      subject
    end

    it "set_spot_idsメソッドを呼び出す" do
      expect(class_instance).to have_received(:set_spot_ids).once
    end

    it "set_spot_idsメソッドの返り値と一致するidのSpotレコード群を順番通りに返す" do
      expect(return_value.ids).to eq(spot_ids)
    end
  end

  describe "#set_spot_ids" do
    subject(:return_value) { class_instance.send(:set_spot_ids) }

    let(:spot_tags) do
      create_list(:spot_tag, 3)
      SpotTag.all.reverse
    end
    let(:spot_ids) { spot_tags.pluck(:spot_id) }

    before { allow(class_instance).to receive(:order_tags).and_return(spot_tags) }

    it "order_tagsメソッドの返り値のレコードから抽出した、spot_idの配列を返す" do
      expect(return_value).to eq(spot_ids)
    end
  end

  describe "#order_tags" do
    subject(:return_value) { class_instance.send(:order_tags) }

    let!(:name1_tags) { create_list(:spot_tag, 2, user: user, name: "name1") }
    let!(:name2_tag) { create(:spot_tag, user: user, name: "name2") }
    let(:another_user) { create(:user) }

    before { create_list(:spot_tag, 3, user: another_user) }

    context "tag_paramsのハッシュに、tag_nameキーの値が存在するとき" do
      let(:ordered_spot_tag_ids) { [name1_tags[1].id, name1_tags[0].id] }
      let(:tag_params) { { tag_name: "name1" } }

      it "指定のユーザーが作成したSpotTagレコードのうち、nameカラムがtag_nameキーの値と一致するレコードを、作成日の降順に並べ替えて返す" do
        expect(return_value.ids).to eq(ordered_spot_tag_ids)
      end
    end

    context "tag_paramsのハッシュに、tag_nameキーの値が存在しないとき" do
      let(:ordered_spot_tag_ids) { [name2_tag.id, name1_tags[1].id, name1_tags[0].id] }
      let(:tag_params) { { tag_name: "" } }

      it "指定のユーザーが作成したSpotTagレコードを、作成日の降順に並べ替えて返す" do
        expect(return_value.ids).to eq(ordered_spot_tag_ids)
      end
    end
  end
end
