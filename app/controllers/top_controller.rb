class TopController < ApplicationController
  before_action :set_categories, :set_allowed_areas, :set_regions, :set_prefecture_hash, only: [:index, :word_search]

  def index
    @q = Spot.ransack(params[:q])
  end

  def map_search
    @spots = Spot.eager_load(:category)
    @regions = Prefecture.pluck(:region, :region_roma).uniq
  end

  def word_search
    if params[:q]["and"]
      @q = Spot.ransack({ combinator: 'and', groupings: set_search_groupings("and") })
    elsif params[:q]["or"]
      @q = Spot.ransack({ combinator: 'or', groupings: set_search_groupings("or") })
    end

    @results = @q.result

    if @q.present?
      @q = Spot.ransack(params[:q]["and"])
    end
  end

  private

  def set_search_groupings(search_method)
    search_params = params[:q][search_method]
    grouping_ary = []

    search_params.keys.each do |key|
      if search_params["name_or_address_cont"]
        keywords = search_params[key].split(/[\p{blank}\s]+/)
        keywords.reduce(grouping_ary){ |ary, word| ary.push({ key => word }) }
      else
        grouping_ary.push({ key => search_params[key] })
      end
    end

    return @search_groupings = grouping_ary.uniq
  end

  def set_categories
    @categories = Category.order_default
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order_default
  end

  def set_regions
    @regions = Prefecture.pluck(:region).uniq
  end

  def set_prefecture_hash
    @prefecture_hash = @regions.reduce({}) do |hash, region|
      hash.merge({ region => Prefecture.find_prefecture_name(region) })
    end
  end
end

