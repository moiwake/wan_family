class RankedForSpecificPeriodQuery < OrderedQueryBase
  attr_reader :like_class, :date, :number

  RANKING_NUMBER = 10

  def initialize(scope:, parent_record:, like_class:, date:, number:)
    super(scope: scope, parent_record: parent_record, like_class: like_class, order_params: { by: "likes_count" })
    @date = date
    @number = number
  end

  def self.call(scope:, parent_record: nil, like_class:, date:, number:)
    new_instance = new(
      scope: scope,
      parent_record: parent_record,
      like_class: like_class,
      date: date,
      number: number
    )
    @scope = new_instance.set_ordered_scope
    @scope = limit_scope
    return @scope
  end

  def self.limit_scope
    @scope.limit(RANKING_NUMBER)
  end

  private

  def group_like_class_record
    like_class_record = set_like_class_record

    grouped_like_class_record = like_class_record.group(:"#{like_class_foreign_key}")
    number = PERIOD_NUMBER

    until grouped_like_class_record.size.length >= RANKING_NUMBER
      number = number + PERIOD_NUMBER + 1
      like_class_record = set_like_class_record(date, number)
      grouped_like_class_record = like_class_record.group(:"#{like_class_foreign_key}")
    end

    return grouped_like_class_record
  end

  def set_like_class_record
    CreatedInSpecificPeriodQuery.call(scope: like_class.constantize.all, date: date, number: number)
  end
end
