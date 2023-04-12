require 'rails_helper'

RSpec.describe ImageBlobs::OrderedQuery, type: :model do
  let!(:images) { create_list(:image, 3, :attached) }
  let(:ordered_query_instance) { ImageBlobs::OrderedQuery.new(scope: nil, parent_record: parent_record, order_params: {}, like_class: "ImageLike") }
  let(:parent_record) { nil }

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

  describe "#search_image_blobs" do
    subject(:return_value) { ordered_query_instance.send(:search_image_blobs) }

    context "parent_recordが単一のImageクラスのオブジェクトのとき" do
      let(:parent_record) { images[0] }
      let(:searched_scope) { parent_record.files_blobs }

      it "parent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end

    context "parent_recordが複数のImageクラスのオブジェクトのとき" do
      let(:parent_record) { [images[0], images[1]] }
      let(:searched_scope) { parent_record[0].files.blobs.or(parent_record[1].files.blobs) }

      it "それぞれのparent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_scope)
      end
    end
  end
end
