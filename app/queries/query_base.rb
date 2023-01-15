class QueryBase
  class << self
    def call(scope: nil, params: {})
      set_default_scope
      order_scope(params)
    end

    private

    def set_default_scope
      scope.all
    end

    def order_scope(scope, params)
      if params[:column] == "created_at"
        return scope = order_asc_or_desc(scope, params[:column], params[:direction])
      elsif params[:sort] == "likes_count"
        return scope = order_likes_count(scope)
      else
        return scope = order_default(scope)
      end
    end

    def order_default(scope)
      scope.order(created_at: :desc, id: :desc)
    end

    def order_asc_or_desc(scope, column, direction)
      scope.order({ column => direction })
    end

    def order_likes_count(scope)
      ids_in_order_likes = set_ids_in_order_likes

      liked_scope = scope.find(ids_in_order_likes)

      not_liked_ids = scope.pluck(:id).difference(ids_in_order_likes)
      not_liked_scope = order_default(scope.where(id: not_liked_ids))

      return liked_scope.push(not_liked_scope).flatten
    end

    def set_ids_in_order_likes
      []
    end
  end
end
