class Spots::SearchsController < ApplicationController
  before_action :set_categories, :set_allowed_areas, :set_regions, :set_prefecture_hash

  def index
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
    params_search = params[:q][search_method]
    grouping_ary = []

    params_search.keys.each do |key|
      if params_search[key].kind_of?(String)
        keywords = params_search[key].split(/[\p{blank}\s]+/)
      else
        keywords = params_search[key]
      end

      keywords.reduce(grouping_ary){ |ary, word| ary.push({ key => word }) }
    end

    return @search_groupings = grouping_ary.flatten
  end

  def set_categories
    @categories = Category.order(:id)
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order(:id)
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

