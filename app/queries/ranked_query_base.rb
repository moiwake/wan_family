class RankedQueryBase < OrderedQueryBase
  RANK_NUMBER = 10

  attr_reader :rank_num

  def initialize(scope:, parent_record:, order_params:, assessment_class:, rank_num:)
    super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    @rank_num = rank_num
  end

  def self.call(scope:, parent_record:, order_params: { by: "assessment" }, assessment_class:, rank_num: RANK_NUMBER)
    @scope = new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class, rank_num: rank_num).limit_scope
    @scope
  end

  def limit_scope
    @scope = set_ordered_scope
    @scope.limit(rank_num)
  end
end
