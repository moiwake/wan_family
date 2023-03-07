class ApplicationController < ActionController::Base
  before_action :set_q
  before_action :set_categories, :set_allowed_areas, :set_regions, :set_prefecture_hash
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  private

  def set_q
    @q ||= Spot.ransack(params[:q])
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
