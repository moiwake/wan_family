module ImageBlobs
  class RankedQuery < RankedQueryBase
    include SearchByParentRecord

    def initialize(scope:, parent_record:, order_params:, assessment_class:, rank_num:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num)
    end

    def self.call(scope: nil, parent_record: Image.all, assessment_class: "ImageLike", rank_num: RANK_NUMBER)
      super
    end
  end
end
