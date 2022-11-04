class SpotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_checked_rule_opt_ids, only: [:edit, :update]
  before_action :set_categories, :set_allowed_areas, :set_option_titles, only: [:new, :create, :edit, :update]

  def index
    @spots = Spot.all
  end

  def new
    @spot_register_form = SpotRegisterForm.new
  end

  def create
    @spot_register_form = SpotRegisterForm.new(attributes: form_params)

    if @spot_register_form.save
      call_spot_history_creator
      flash[:notice] = "#{@spot_register_form.spot.name}を登録しました。"
      redirect_to spot_path(@spot_register_form.spot)
    else
      render "new"
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(spot: @spot)
  end

  def update
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: form_params, spot: @spot, rules: @spot.rule)

    if @spot_register_form.save
      call_spot_history_creator
      flash[:notice] = "#{@spot_register_form.spot.name}の登録内容を変更しました。"
      redirect_to spot_path(@spot)
    else
      render "edit"
    end
  end

  private

  def form_params
    spot_params = [:name, :latitude, :longitude, :address, :official_site, :image, :allowed_area_id, :category_id]

    @rule_params = []
    RuleOption.pluck(:id).each { |i| @rule_params << "#{i}" }

    params.require(:spot_register_form).permit(spot_attributes: spot_params, rule_attributes: [answer: @rule_params])
  end

  def set_categories
    @categories = Category.order(:id)
  end

  def set_allowed_areas
    @allowed_areas = AllowedArea.order(:id)
  end

  def set_option_titles
    @titles = OptionTitle.order(:id).includes(:rule_option)
  end

  def set_checked_rule_opt_ids
    @checked_rule_opt_ids = @spot.decorate.find_checked_rules.pluck(:rule_option_id)
  end

  def call_spot_history_creator
    SpotHistoryCreator.call(spot: @spot_register_form.spot, user: current_user)
  end
end
