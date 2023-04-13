class RankedForSpecificPeriodQuery < OrderedQueryBase
  attr_reader :like_class, :date, :number

  RANKING_NUMBER = 10

  def initialize(scope:, parent_record:, like_class:, date:, number:)
    super(scope: scope, parent_record: parent_record, like_class: like_class, order_params: { by: "likes_count" })
    @date = date
    @number = number
  end

  def self.call(scope:, parent_record: nil, like_class:, date:, number:)
    @scope = new(
      scope: scope,
      parent_record: parent_record,
      like_class: like_class,
      date: date,
      number: number
    ).set_ranked_scope_for_specific_period

    return @scope
  end

  def set_ranked_scope_for_specific_period
    @scope = set_ordered_scope
    @scope = limit_scope
  end

  private

  def limit_scope
    @scope.limit(RANKING_NUMBER)
  end

  def group_like_class_records
    @grouped_like_class_records = set_grouped_like_class_records

    @loop_limit = 0
    until @grouped_like_class_records.size.length >= RANKING_NUMBER || @loop_limit == 5
      @loop_limit = @loop_limit + 1
      @grouped_like_class_records = fill_records_up_to_rank_num
    end

    return @grouped_like_class_records
  end

  def set_grouped_like_class_records
    set_like_class_records.group(:"#{like_class_foreign_key}")
  end

  def fill_records_up_to_rank_num
    @number = number + (number + 1)
    return set_grouped_like_class_records
  end

  def set_like_class_records
    CreatedInSpecificPeriodQuery.call(scope: like_class.constantize.all, date: date, number: number)
  end
end
