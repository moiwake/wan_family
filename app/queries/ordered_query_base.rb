class OrderedQueryBase
  attr_reader :scope, :parent_record, :order_params, :like_class, :like_class_foreign_key

  def initialize(scope: nil, parent_record: nil, order_params: nil, like_class: nil)
    @scope = scope
    @parent_record = parent_record
    @order_params = order_params
    @like_class = like_class
  end

  def self.call(scope: nil, parent_record: nil, order_params: {}, like_class: nil)
    @scope = new(scope: scope, parent_record: parent_record, order_params: order_params, like_class: like_class).set_ordered_scope
    return @scope
  end

  def set_ordered_scope
    @scope = set_scope
    @scope = order_scope
  end

  private

  def set_scope
    if parent_record.nil?
      scope
    else
      if parent_record && parent_record[0]
        scope.where({"#{parent_record.model.name.downcase}_id" => parent_record.ids})
      elsif parent_record
        scope.where({"#{parent_record.class.name.downcase}_id" => parent_record.id})
      end
    end
  end

  def order_scope
    if order_params[:by] == "created_at"
      order_asc_or_desc
    elsif order_params[:by] == "likes_count"
      order_by_likes
    else
      order_default
    end
  end

  def order_asc_or_desc
    scope.order({
      order_params[:by] => order_params[:direction],
      "id" => order_params[:direction]
    })
  end

  def order_by_likes
    scope_ids = set_scope_ids_in_likes_order
    scope.where(id: scope_ids).order([Arel.sql("field(#{scope.model.table_name}.id, ?)"), scope_ids])
  end

  def set_scope_ids_in_likes_order
    set_liked_scope_ids.push(set_not_liked_scope_ids).flatten
  end

  def set_not_liked_scope_ids
    order_default.ids.difference(@liked_scope_ids)
  end

  def set_liked_scope_ids
    @liked_scope_ids = order_like_class_record.pluck(:"#{like_class_foreign_key}")
  end

  def order_like_class_record
    group_like_class_record.order("count(#{like_class_foreign_key}) desc")
  end

  def group_like_class_record
    like_class.constantize.group(:"#{like_class_foreign_key}")
  end

  def like_class_foreign_key
    @like_class_foreign_key = "#{scope.model.name.demodulize.downcase}_id"
  end

  def order_default
    scope.order(created_at: :desc, id: :desc)
  end
end
