require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#paginated?" do
    context "引数に渡したレコード群がページネーションのメソッドを利用できるとき" do
      let(:records) { create_list(:spot, 2)[0].class.all.page(params[:page]) }

      before do
        allow(helper).to receive(:paginate).with(records)
        helper.paginated?(records)
      end

      it "レコード群を引数に、paginateメソッドを呼び出す" do
        expect(helper).to have_received(:paginate).once.with(records)
      end
    end
  end

  describe "#who_signed_in?" do
    let(:user) { double("user") }
    let(:admin) { double("admin") }

    before do
      allow(helper).to receive(:current_user).and_return(nil)
      allow(helper).to receive(:current_admin).and_return(nil)
    end

    context "ログインしているユーザーが存在するとき" do
      it "userを返す" do
        allow(helper).to receive(:current_user).and_return(user)
        expect(helper.who_signed_in?).to eq("user")
      end
    end

    context "ログインしている管理者が存在するとき" do
      it "adminを返す" do
        allow(helper).to receive(:current_admin).and_return(admin)
        expect(helper.who_signed_in?).to eq("admin")
      end
    end

    context "ログインしていないとき" do
      it "othersを返す" do
        expect(helper.who_signed_in?).to eq("others")
      end
    end
  end

  describe "#ary_present_and_include_ele?" do
    let(:ary) { [1, 2, 3] }

    context "引数に渡された配列が存在するとき" do
      context "その配列に、引数に渡された値が含まれていれば" do
        it "trueを返す" do
          expect(helper.ary_present_and_include_ele?(ary: ary, ele: 1)).to eq(true)
        end
      end

      context "その配列に、引数に渡された値が含まれていなければ" do
        it "falseを返す" do
          expect(helper.ary_present_and_include_ele?(ary: ary, ele: 0)).to eq(false)
        end
      end
    end

    context "引数に渡された配列が存在しないとき" do
      it "falseを返す" do
        expect(helper.ary_present_and_include_ele?(ary: nil)).to eq(false)
      end
    end
  end

  describe "#set_image_id" do
    let(:image) { create(:image, :attached) }
    let(:image_blob) { image.files_blobs[0] }

    context "引数にimage_idが渡されているとき" do
      it "引数のimage_idをそのまま返す" do
        expect(helper.set_image_id(image_id: image.id, image_blob: image_blob)).to eq(image.id)
      end
    end

    context "引数にimage_idが渡されていない" do
      it "引数に渡したBlobレコードに関連するImageレコードのidを返す" do
        expect(helper.set_image_id(image_blob: image_blob)).to eq(image.id)
      end
    end
  end

  describe "#set_spot_id" do
    let(:image) { create(:image, :attached) }
    let(:image_blob) { image.files_blobs[0] }

    context "引数にspot_idが渡されているとき" do
      it "引数のspot_idをそのまま返す" do
        expect(helper.set_spot_id(spot_id: image.spot.id, image_blob: image_blob)).to eq(image.spot.id)
      end
    end

    context "引数にimage_idが渡されていない" do
      it "引数に渡したBlobレコードに関連するSpotレコードのidを返す" do
        expect(helper.set_spot_id(image_blob: image_blob)).to eq(image.spot.id)
      end
    end
  end
end
