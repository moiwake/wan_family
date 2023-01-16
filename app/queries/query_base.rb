class QueryBase
  class << self
    def call(scope: nil, params: {})
      set_default_scope(scope)
      order_scope(scope, params)
    end

    private

    def set_default_scope(scope)
      scope.all
    end

    def order_scope(scope, params)
      if params[:by] == "created_at"
        return scope = order_asc_or_desc(scope, params[:by], params[:direction])
      elsif params[:by] == "likes_count"
        return scope = order_likes_count(scope)
      else
        return scope = order_default(scope)
      end
    end

    def order_default(scope)
      scope.order(created_at: :desc, id: :desc)
    end

    def order_asc_or_desc(scope, column, direction)
      scope.order({ column => direction, "id" => direction})
    end

    def order_likes_count(scope)
      liked_ids = set_ids_in_order_likes

      not_liked_ids = scope.pluck(:id).difference(liked_ids).reverse.uniq
      not_liked_scope = order_default(scope.where(id: not_liked_ids))

      scope_ids = liked_ids.push(not_liked_ids).flatten

      return scope.where(id: scope_ids).order([Arel.sql('field(id, ?)'), scope_ids])
    end

    def set_ids_in_order_likes
      []
    end
  end
end