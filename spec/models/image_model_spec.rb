require 'rails_helper'
require 'support/shared_examples/model_spec'

RSpec.describe Image, type: :model do
  let!(:image) { create(:image, :attached) }
  let!(:attribute) { :files }

  context "全カラムのデータが有効なとき" do
    let!(:valid_object) { image }

    it_behaves_like "the object is valid"
  end

  describe "presenceのバリデーション" do
    let(:invalid_object) { build(:image, attribute => nil) }
    let(:message) { "を入力してください" }

    context "filesカラム" do
      context "nilのとき" do
        let(:type) { :nil }

        it_behaves_like "adds validation error messages"
      end
    end
  end

  describe "content_typeのバリデーション" do
    let(:invalid_object) { build(:image) }
    let(:message) { "のファイル形式が不正です。" }

    context "filesカラムに不正な形式のファイルを添付したとき" do
      before do
        invalid_object.files.attach({ io: File.open('spec/fixtures/test.txt'), filename: 'test.txt' })
      end

      it_behaves_like "adds validation error messages"
    end
  end

  describe "size_rangeのバリデーション" do
    let(:invalid_object) { build(:image) }

    context "filesカラムに1バイト以下のファイルを添付したとき" do
      let(:message) { "を1バイト以上のサイズにしてください。" }

      before do
        invalid_object.files.attach({ io: File.open('spec/fixtures/images/0byte.png'), filename: '0byte.png' })
      end

      it_behaves_like "adds validation error messages"
    end

    context "filesカラムに5メガバイト以上のファイルを添付したとき" do
      let(:message) { "を5MB以下のサイズにしてください。" }

      before do
        invalid_object.files.blobs << ActiveStorage::Blob.new(content_type: "image/png", byte_size: 6.megabytes)
      end

      it_behaves_like "adds validation error messages"
    end
  end
end
