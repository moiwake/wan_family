module ImageBlobs
  class OrderedQuery < OrderedQueryBase
    include SearchByParentRecord

    def initialize(scope:, parent_record:, order_params:, assessment_class:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end

    def self.call(scope: nil, parent_record: nil, order_params: {}, assessment_class: "ImageLike")
      parent_record ||= Image.all
      super
    end
  end
end
