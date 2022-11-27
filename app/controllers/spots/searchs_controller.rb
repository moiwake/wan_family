class Spots::SearchsController < ApplicationController
  before_action :set_search_groupings, only: [:index]
  before_action :set_categories, :set_allowed_areas, only: [:index]

  def index
    @q = Spot.ransack({ combinator: 'and', groupings: @search_groupings })
    @results = @q.result

    if params[:q].present?
      @q = Spot.ransack(params[:q])
    end
  end

  private

  def set_search_groupings
    params_keys = params[:q].keys

    grouping_ary = params_keys.map do |key|
      keywords = params[:q][key].split(/[\p{blank}\s]+/)
      keywords.reduce([]){|ary, word| ary.push({ key => word })}
    end

    @search_groupings = grouping_ary.flatten
  end

  def set_categories
    @categories = Category.order(:id)
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order(:id)
  end
end

