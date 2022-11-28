class PagesController < ApplicationController
  before_action :set_categories, :set_allowed_areas, :set_regions, only: [:index, :show]

  def index
    @q = Spot.ransack(params[:q])
  end

  private

  def set_categories
    @categories = Category.order(:id)
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order(:id)
  end

  def set_regions
    @regions = Prefecture.pluck(:region).uniq
  end
end
