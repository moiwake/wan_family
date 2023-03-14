class RankedQueryBase
  attr_reader :scope, :parent_record, :rank_class_record, :rank_class_foreign_key

  RANKING_NUMBER = 10

  def initialize(scope:, parent_record:, rank_class_record:)
    @scope = scope
    @parent_record = parent_record
    @rank_class_record = rank_class_record
  end

  def self.call(scope:, parent_record:, rank_class_record:)
    new_instance = new(scope: scope, parent_record: parent_record, rank_class_record: rank_class_record)
    @scope = new_instance.set_ranked_scope
    return @scope
  end

  def set_ranked_scope
    scope_ids = pluck_foreign_key_in_rank_order
    set_scope.where(id: scope_ids).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), scope_ids])
  end

  private

  def set_scope
    scope
  end

  def pluck_foreign_key_in_rank_order
    limit_rank_class_record.pluck(:"#{rank_class_foreign_key}")
  end

  def limit_rank_class_record
    order_rank_class_record.limit(RANKING_NUMBER)
  end

  def order_rank_class_record
    set_grouped_rank_class_record.order("count(#{rank_class_foreign_key}) desc")
  end

  def set_grouped_rank_class_record
    if parent_record && parent_record[0]
      @rank_class_record = rank_class_record.where(image_id: parent_record.ids)
    elsif parent_record
      @rank_class_record = rank_class_record.where(image_id: parent_record.id)
    end

    rank_class_record.group(:"#{rank_class_foreign_key}")
  end

  def rank_class_foreign_key
    @rank_class_foreign_key = "#{scope.model.name.demodulize.downcase}_id"
  end
end
