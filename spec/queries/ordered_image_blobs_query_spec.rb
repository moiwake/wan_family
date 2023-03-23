require 'rails_helper'

RSpec.describe OrderedImageBlobsQuery, type: :model do
  let!(:images) { create_list(:image, 3, :attached) }

  describe "#call" do
    context "引数なしでcallメソッドを呼び出すとき" do
      let(:ordered_blobs_query_instance) { OrderedImageBlobsQuery.new(default_arguments) }
      let(:default_arguments) { { scope: nil, parent_record: Image.all, order_params: {}, like_class: "ImageLike" } }

      before do
        allow(OrderedImageBlobsQuery).to receive(:new).and_return(ordered_blobs_query_instance)
        OrderedImageBlobsQuery.call
      end

      it "デフォルト値を引数に渡して、newメソッドを呼び出す" do
        expect(OrderedImageBlobsQuery).to have_received(:new).once.with(default_arguments)
      end
    end
  end

  describe "#set_scope" do
    let(:ordered_blobs_query_instance) { OrderedImageBlobsQuery.new(scope: nil, parent_record: nil, order_params: {}, like_class: "ImageLike") }

    subject(:return_value) { ordered_blobs_query_instance.send(:set_scope) }

    before { allow(ordered_blobs_query_instance).to receive(:search_blobs).and_return(searched_scope) }

    context "scopeのBlobレコード群が存在するとき" do
      let(:searched_scope) { instance_double("blobs") }

      it "search_blobsメソッドの返り値のBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end

    context "scopeのBlobレコード群が存在しないとき" do
      let(:searched_scope) { nil }

      it "空のActiveRecord::Relationオブジェクトを返す" do
        expect(return_value.any?).to eq(false)
        expect(return_value.class.name).to eq("ActiveRecord::Relation")
      end
    end
  end

  describe "#search_blobs" do
    let(:ordered_blobs_query_instance) { OrderedImageBlobsQuery.new(scope: nil, parent_record: parent_record, order_params: {}, like_class: "ImageLike") }

    subject(:return_value) { ordered_blobs_query_instance.send(:search_blobs) }

    context "parent_recordが単一のImageクラスのオブジェクトのとき" do
      let(:parent_record) { images[0] }
      let(:searched_scope) { parent_record.files.blobs }

      it "parent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end

    context "parent_recordが複数のImageクラスのオブジェクトのとき" do
      let(:parent_record) { [images[0], images[1]] }
      let(:searched_scope) { images[0].files.blobs.or(images[1].files.blobs) }

      it "それぞれのparent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end
  end
end
