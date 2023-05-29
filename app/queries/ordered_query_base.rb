class OrderedQueryBase
  attr_reader :scope, :parent_record, :order_params, :assessment_class, :assessment_class_foreign_key

  def initialize(scope: nil, parent_record: nil, order_params: nil, assessment_class: nil)
    @scope = scope
    @parent_record = parent_record
    @order_params = order_params
    @assessment_class = assessment_class
  end

  def self.call(scope: nil, parent_record: nil, order_params: {}, assessment_class: nil)
    @scope = new(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class).set_ordered_scope
    @scope
  end

  def set_ordered_scope
    @scope = set_scope
    @scope = order_scope
  end

  private

  def set_scope
    if parent_record.nil?
      scope.distinct
    else
      if parent_record && parent_record[0]
        scope.where({ "#{parent_record.model.name.downcase}_id" => parent_record.ids })
      elsif parent_record
        scope.where({ "#{parent_record.class.name.downcase}_id" => parent_record.id })
      end
    end
  end

  def order_scope
    if order_params[:by] == "created_at"
      order_asc_or_desc
    elsif order_params[:by] == "assessment"
      order_by_likes
    else
      order_default
    end
  end

  def order_asc_or_desc
    scope.order({
      order_params[:by] => order_params[:direction],
      "id" => order_params[:direction],
    })
  end

  def order_by_likes
    @reflection = get_reflection_of_assessment_class

    if @reflection
      count_attr = @reflection.counter_cache_column
      scope.order("#{count_attr}": :desc)
    else
      ordered_scope_ids = set_scope_ids_in_likes_order
      order_scope_by_ids(ordered_scope_ids)
    end
  end

  def order_default
    if scope.model.attribute_types.keys.include?("updated_at")
      scope.order(updated_at: :desc, created_at: :desc, id: :desc)
    else
      scope.order(created_at: :desc, id: :desc)
    end
  end

  def get_reflection_of_assessment_class
    assessment_class.constantize.reflect_on_all_associations.select do |ref|
      ref.plural_name == scope.model.table_name
    end.first
  end

  def order_scope_by_ids(ordered_scope_ids)
    scope.where(id: ordered_scope_ids).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), ordered_scope_ids])
  end

  def set_scope_ids_in_likes_order
    set_liked_scope_ids.push(set_not_liked_scope_ids).flatten
  end

  def set_not_liked_scope_ids
    scope.order(id: :desc).ids.difference(@liked_scope_ids)
  end

  def set_liked_scope_ids
    set_assessment_class_foreign_key
    @liked_scope_ids = order_assessment_class_records.pluck(:"#{assessment_class_foreign_key}")
  end

  def order_assessment_class_records
    group_assessment_class_records.order(Arel.sql("count(#{assessment_class_foreign_key}) desc"))
  end

  def group_assessment_class_records
    assessment_class.constantize.group(:"#{assessment_class_foreign_key}")
  end

  def set_assessment_class_foreign_key
    @assessment_class_foreign_key = "#{scope.model.name.demodulize.downcase}_id"
  end
end
