require 'rails_helper'

RSpec.describe OrderedImageBlobsQuery, type: :model do
  let!(:images) { create_list(:image, 3, :attached) }
  let!(:files) { ActiveStorage::Attachment.where(record_type: "Image") }
  let!(:blobs) { images[0].files.blobs }

  describe "#call" do
    let(:variant) { true }
    let(:order_params) { {} }

    before do
      allow(OrderedImageBlobsQuery).to receive(:set_files).and_return(files)
      allow(OrderedImageBlobsQuery).to receive(:set_default_scope).and_return(blobs)
      allow(OrderedImageBlobsQuery).to receive(:preload_variant_record).and_return(blobs)
      allow(OrderedImageBlobsQuery).to receive(:order_scope)
      OrderedImageBlobsQuery.send(:call, blobs: blobs, parent_image: images, variant: variant, order_params: order_params)
    end

    it "引数の値を渡してset_filesメソッドを呼び出す" do
      expect(OrderedImageBlobsQuery).to have_received(:set_files).once.with(images)
    end

    it "引数の値を渡してset_default_scopeメソッドを呼び出す" do
      expect(OrderedImageBlobsQuery).to have_received(:set_default_scope).once.with(blobs, files)
    end

    it "引数の値を渡してpreload_variant_recordメソッドを呼び出す" do
      expect(OrderedImageBlobsQuery).to have_received(:preload_variant_record).once.with(blobs, variant)
    end

    it "引数の値を渡してorder_scopeメソッドを呼び出す" do
      expect(OrderedImageBlobsQuery).to have_received(:order_scope).once.with(blobs, order_params)
    end
  end

  describe "#set_files" do
    before do
      allow(OrderedImageBlobsQuery).to receive(:search_by_parent_image)
      OrderedImageBlobsQuery.send(:set_files, images)
    end

    it "引数の値を渡してsearch_by_parent_imageメソッドを呼び出す" do
      expect(OrderedImageBlobsQuery).to have_received(:search_by_parent_image).once.with(files, images)
    end
  end

  describe "#search_by_parent_image" do
    context "引数parent_imageがnilのとき" do
      let(:parent_image) { nil }

      it "空の配列を返す" do
        expect(OrderedImageBlobsQuery.send(:search_by_parent_image, files, parent_image)).to eq([])
      end
    end

    context "引数parent_imageがnilではないとき" do
      let(:parent_image) { images }
      let(:searched_files) { files.where(record_id: images.pluck(:id)) }

      it "parent_imageのレコードと関連するFilesレコード群を返す" do
        expect(OrderedImageBlobsQuery.send(:search_by_parent_image, files, parent_image)).to eq(searched_files)
      end
    end
  end

  describe "#set_default_scope" do
    let(:scope) { ActiveStorage::Blob.all }
    let(:saerched_scope) { ActiveStorage::Blob.where(id: files.pluck(:blob_id)) }

    subject { OrderedImageBlobsQuery.send(:set_default_scope, scope, files) }

    before { allow(OrderedImageBlobsQuery).to receive(:preload_attachments_and_record).and_return(scope) }

    it "引数の値を渡してpreload_attachments_and_recordメソッドを呼び出す" do
      subject
      expect(OrderedImageBlobsQuery).to have_received(:preload_attachments_and_record).once.with(scope)
    end

    it "引数のblob_idカラムの値をidに持つ、Blobレコード群を返す" do
      expect(subject).to eq(saerched_scope)
    end
  end

  describe "#preload_attachments_and_record" do
    let(:scope) { ActiveStorage::Blob.where(id: files.pluck(:blob_id)) }

    subject { OrderedImageBlobsQuery.send(:preload_attachments_and_record, scope) }

    it "Blobレコード群を返す" do
      expect(subject).to eq(scope)
    end

    it "引数にattachmentsテーブルとimagesテーブルをpreloadする" do
      expect(subject[0].association(:attachments).loaded?).to eq(true)
      expect(subject[0].attachments[0].association(:record).loaded?).to eq(true)
    end
  end

  describe "#preload_variant_record" do
    let(:scope) { ActiveStorage::Blob.where(id: files.pluck(:blob_id)) }

    subject { OrderedImageBlobsQuery.send(:preload_variant_record, scope, variant) }

    context "引数のvariantがtrueのとき" do
      let(:variant) { true }

      it "Blobレコード群を返す" do
        expect(subject).to eq(scope)
      end

      it "引数にvariant_recordsテーブルをpreloadする" do
        expect(subject[0].association(:variant_records).loaded?).to eq(true)
      end
    end

    context "引数のvariantがfalseのとき" do
      let(:variant) { false }

      it "Blobレコード群を返す" do
        expect(subject).to eq(scope)
      end

      it "引数にvariant_recordsテーブルをpreloadしない" do
        expect(subject[0].variant_records.loaded?).to eq(false)
      end
    end
  end

  describe "#set_ids_in_order_likes" do
    let!(:like_image_A) { create_list(:like_image, 3, image_id: images[0].id, blob_id: images[0].files[0].blob.id) }
    let!(:like_image_B) { create_list(:like_image, 2, image_id: images[1].id, blob_id: images[1].files[0].blob.id) }
    let!(:like_image_C) { create_list(:like_image, 1, image_id: images[2].id, blob_id: images[2].files[0].blob.id) }
    let(:ordered_like_ids) { [images[0].files[0].blob.id, images[1].files[0].blob.id, images[2].files[0].blob.id] }

    it "同じblob_idを持つLikeImageレコードの数が多い順に、blob_idの配列を返す" do
      expect(OrderedImageBlobsQuery.send(:set_ids_in_order_likes)).to eq(ordered_like_ids)
    end
  end
end
