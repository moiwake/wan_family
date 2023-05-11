require "rails_helper"
require 'support/shared_examples/model_spec'

RSpec.describe SpotTag, type: :model do
  let!(:spot_tag) { create(:spot_tag) }

  context "全カラムのデータが有効なとき" do
    let(:valid_object) { spot_tag }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:spot_tag, attribute => (type == :nil ? nil : "")) }
    let(:message) { "を入力してください" }

    context "nameカラム" do
      let(:attribute) { :name }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end

      context "空文字のとき" do
        let(:type) { :empty }

        it_behaves_like "adds validation error messages"
      end
    end

    context "user_idカラム" do
      let(:attribute) { :user }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end

    context "spot_idカラム" do
      let(:attribute) { :spot }

      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "scope" do
    let!(:user) { create(:user) }
    let!(:anothre_user) { create(:user) }

    describe "scope#get_tag_names_user_created" do
      before do
        create_list(:spot_tag, 2, user: user, name: "tag_name_1")
        create(:spot_tag, user: user, name: "tag_name_2")
        create(:spot_tag, user: anothre_user)
      end

      it "更新日、でなければ作成日の降順に並び替えした、引数のuser_idを持つSpotTagレコードの、重複を除いたnameカラムの配列を返す" do
        expect(SpotTag.get_tag_names_user_created(user_id: user.id)).to eq(["tag_name_2", "tag_name_1"])
      end
    end

    describe "scope#get_tags_user_put_on_spot" do
      let!(:spot) { create(:spot) }
      let(:spot_tags) { SpotTag.where(user_id: user.id, spot_id: spot.id).order(updated_at: :desc, created_at: :desc, id: :desc) }

      before { create_list(:spot_tag, 2, user: user, spot: spot) }

      it "更新日、でなければ作成日の降順に並び替えした、引数のuser_idとspot_idを持つSpotTagレコード群を返す" do
        expect(SpotTag.get_tags_user_put_on_spot(user_id: user.id, spot_id: spot.id)).to eq(spot_tags)
      end
    end
  end
end
