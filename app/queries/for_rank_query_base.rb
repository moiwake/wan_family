class ForRankQueryBase
  attr_reader :scope, :rank_class, :rank_class_foreign_key

  RANKING_DISPLAY_NUMBER = 10

  def initialize(scope:, rank_class:)
    @scope = scope
    @rank_class = rank_class
  end

  def self.call(scope:, rank_class:)
    @scope = new(scope: scope, rank_class: rank_class).set_ranked_scope
    return @scope
  end

  def set_ranked_scope
    scope_ids = pluck_foreign_key_in_rank_order
    scope.where(id: scope_ids).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), scope_ids])
  end

  private

  def pluck_foreign_key_in_rank_order
    limit_ordered_rank_class.pluck(:"#{rank_class_foreign_key}")
  end

  def limit_ordered_rank_class
    order_rank_class.limit(RANKING_DISPLAY_NUMBER)
  end

  def order_rank_class
    rank_class.constantize.group(:"#{rank_class_foreign_key}").order("count(#{rank_class_foreign_key}) desc")
  end

  def rank_class_foreign_key
    @rank_class_foreign_key = "#{scope.model.name.demodulize.downcase}_id"
  end
end
