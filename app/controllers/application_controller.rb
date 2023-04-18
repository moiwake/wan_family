class ApplicationController < ActionController::Base
  before_action :set_q
  before_action :set_categories, :set_allowed_areas, :set_regions, unless: proc { request.xhr? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  private

  def set_q
    @q ||= Spot.ransack(session[:q])
  end

  def set_categories
    @categories = Category.order_default
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order_default
  end

  def set_regions
    @regions = Region.all.preload(prefectures: :spots)
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
