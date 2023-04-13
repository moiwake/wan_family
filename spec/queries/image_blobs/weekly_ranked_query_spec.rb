require 'rails_helper'

RSpec.describe ImageBlobs::WeeklyRankedQuery, type: :model do
  let(:class_instance) { ImageBlobs::WeeklyRankedQuery.new(scope: nil, parent_record: Image.all, like_class: "ImageLike", date: "days", number: period_num) }
  let(:period_num) { stub_const("ImageBlobs::WeeklyRankedQuery::PERIOD_NUMBER", 6) }

  describe "#call" do
    before do
      create_list(:image, 2, :attached)
      allow(RankedForSpecificPeriodQuery).to receive(:call)
      ImageBlobs::WeeklyRankedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(RankedForSpecificPeriodQuery).to have_received(:call).once.with(scope: nil, parent_record: Image.all, like_class: "ImageLike", date: "days", number: period_num)
    end
  end

  describe "#set_scope" do
    subject(:return_value) { class_instance.send(:set_scope) }

    before { allow(class_instance).to receive(:search_image_blobs).and_return(searched_scope) }

    context "Blobレコード群が存在するとき" do
      let(:searched_scope) { instance_double("blobs") }

      it "search_image_blobsメソッドの返り値のBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end

    context "Blobレコード群が存在しないとき" do
      let(:searched_scope) { nil }

      it "空のActiveRecord::Relationオブジェクトを返す" do
        expect(return_value.any?).to eq(false)
        expect(return_value.class.name).to eq("ActiveRecord::Relation")
      end
    end
  end
end
