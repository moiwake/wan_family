require 'rails_helper'

RSpec.describe ImageBlobs::OrderedQuery, type: :model do
  let(:scope) { nil }
  let(:parent_record) { Image.all }
  let(:assessment_class) { "ImageLike" }
  let(:order_params) { {} }
  let(:ordered_query_instance) { ImageBlobs::OrderedQuery.new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class) }

  describe "#call" do
    before do
      allow(OrderedQueryBase).to receive(:call)
      ImageBlobs::OrderedQuery.call
    end

    it "指定した引数を渡して、親クラスのcallメソッドを呼び出す" do
      expect(OrderedQueryBase).to have_received(:call).once.with(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end
  end
end
