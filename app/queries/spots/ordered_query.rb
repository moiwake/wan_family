module Spots
  class OrderedQuery < OrderedQueryBase
    def initialize(scope:, parent_record:, order_params:, assessment_class:)
      super(scope: scope, parent_record: parent_record, order_params: order_params, assessment_class: assessment_class)
    end

    def self.call(scope: nil, parent_record: nil, order_params: {}, assessment_class: "SpotFavorite")
      scope ||= Spot.all
      super
    end

    private

    def set_scope
      @scope = scope.distinct
    end

    def order_asc_or_desc
      ordered_scope_ids = SpotHistory.
        order(order_params[:by] => order_params[:direction], "id" => order_params[:direction]).
        pluck(:spot_id)
      order_scope_by_ids(ordered_scope_ids)
    end

    def order_default
      ordered_scope_ids = SpotHistory.order(created_at: :desc, id: :desc).pluck(:spot_id)
      order_scope_by_ids(ordered_scope_ids)
    end
  end
end
