class PagesController < ApplicationController
  before_action :set_q, only: [:index]
  before_action :set_categories, :set_allowed_areas, only: [:index, :show]

  def index
    @rule_options = RuleOption.all
  end

  private

  def set_q
    @q = Spot.ransack(params[:q])
  end

  def set_categories
    @categories = Category.order(:id)
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order(:id)
  end
end
