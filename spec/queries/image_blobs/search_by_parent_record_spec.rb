require 'rails_helper'

class DummyClass
  include ImageBlobs::SearchByParentRecord

  attr_reader :parent_record

  def initialize(parent_record: nil)
    @parent_record = parent_record
  end
end

RSpec.describe "ImageBlobs::SearchByParentRecord", :type => :model do
  let!(:images) { create_list(:image, 2, :attached) }

  describe "#set_scope" do
    subject(:return_value) { included_class_inctance.send(:set_scope) }

    let(:included_class_inctance) { DummyClass.new }

    before { allow(included_class_inctance).to receive(:search_image_blobs).and_return(searched_scope) }

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
    subject(:return_value) { included_class_inctance.search_image_blobs }

    let(:included_class_inctance) { DummyClass.new(parent_record: parent_record) }

    context "parent_recordが単一のImageクラスのオブジェクトのとき" do
      let(:parent_record) { images[0] }
      let(:searched_blobs) { parent_record.files_blobs }

      it "parent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_blobs)
      end
    end

    context "parent_recordが複数のImageクラスのオブジェクトのとき" do
      let(:parent_record) { [images[0], images[1]] }
      let(:searched_blob) { parent_record[0].files.blobs.or(parent_record[1].files.blobs) }

      it "それぞれのparent_recordに関連するBlobレコード群を返す" do
        expect(return_value).to eq(searched_blob)
      end
    end
  end
end
