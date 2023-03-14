class RankedForSpecificPeriodQuery < RankedQueryBase
  attr_reader :rank_class_scope, :date, :number

  RANKING_NUMBER = 10

  def initialize(scope:, parent_record:, rank_class_record:, rank_class_scope:, date:, number:)
    @rank_class_scope = rank_class_scope
    @date = date
    @number = number
    super(scope: scope, parent_record: parent_record, rank_class_record: rank_class_record)
  end

  def self.call(scope:, parent_record: nil, rank_class_scope:, date:, number:)
    new_instance = new(
      scope: scope,
      parent_record: parent_record,
      rank_class_record: CreatedInSpecificPeriodQuery.call(scope: rank_class_scope, date: date, number: number),
      rank_class_scope: rank_class_scope,
      date: date,
      number: number
    )
    @scope = new_instance.set_ranked_scope
    return @scope
  end

  def set_grouped_rank_class_record
    grouped_rank_class_record = rank_class_record.group(:"#{rank_class_foreign_key}")
    number = PERIOD_NUMBER

    until grouped_rank_class_record.size.length >= RANKING_NUMBER
      number = number + PERIOD_NUMBER + 1
      rank_class_record = CreatedInSpecificPeriodQuery.call(scope: rank_class_scope, date: date, number: number)
      grouped_rank_class_record = rank_class_record.group(:"#{rank_class_foreign_key}")
    end

    return grouped_rank_class_record
  end
end
