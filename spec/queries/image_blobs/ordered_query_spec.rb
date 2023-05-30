require 'rails_helper'

RSpec.describe ImageBlobs::OrderedQuery, type: :model do
  let(:ordered_query_instance) { ImageBlobs::OrderedQuery.new(scope: nil, parent_record: nil, order_params: {}, assessment_class: "ImageLike") }

  describe "#call" do
    before do
      create_list(:image, 2, :attached)
      allow(OrderedQueryBase).to receive(:call)
      ImageBlobs::OrderedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(OrderedQueryBase).to have_received(:call).once.with(scope: nil, parent_record: Image.all, order_params: {}, assessment_class: "ImageLike")
    end
  end

  describe "#set_scope" do
    subject(:return_value) { ordered_query_instance.send(:set_scope) }

    before { allow(ordered_query_instance).to receive(:search_image_blobs).and_return(searched_scope) }

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
