module Reviews
  class OrderedQuery < OrderedQueryBase
    def initialize(scope:, parent_record:, order_params:, assessment_class:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end

    def self.call(scope: nil, parent_record: nil, order_params: {}, assessment_class: "ReviewHelpfulness")
      scope ||= Review.all
      super
    end

    def order_scope
      if order_params[:by] == "created_at"
        order_asc_or_desc
      elsif order_params[:by] == "assessment"
        order_by_likes
      elsif order_params[:by] == "spot_name"
        order_by_spot_name
      else
        order_default
      end
    end

    def order_by_spot_name
      ordered_scope_ids = Spot.where(id: set_spot_ids).order(:name).ids
      scope.where(spot_id: ordered_scope_ids).order([Arel.sql("field(reviews.spot_id, ?)"), ordered_scope_ids])
    end

    def set_spot_ids
      scope.pluck(:spot_id)
    end
  end
end
