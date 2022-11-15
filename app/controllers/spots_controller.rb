class SpotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_categories, :set_allowed_areas, :set_option_titles, except: [:index, :show]

  def index
    @spots = Spot.all
  end

  def new
    session.delete(:params)
    @spot_register_form = SpotRegisterForm.new
  end

  def new_confirm
    @spot_register_form = SpotRegisterForm.new(attributes: form_params)
    session[:params] = form_params

    if @spot_register_form.invalid?
      @spot_register_form.add_spot_errors_spot
      set_attached_rule_opt_ids(@spot_register_form.spot)
      render "new"
    end
  end

  def back_new
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_attached_rule_opt_ids(@spot_register_form.spot)
		render "new"
	end

  def create
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    session.delete(:params)

    if @spot_register_form.save
      SpotHistoryCreator.call(spot: @spot_register_form.spot, user: current_user, history: "新規登録")
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
    session.delete(:params)
    @spot = Spot.find(params[:id])
    set_attached_rule_opt_ids(@spot)
    @spot_register_form = SpotRegisterForm.new(spot: @spot)
  end

  def edit_confirm
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: form_params, spot: @spot, rules: @spot.rule)
    session[:params] = form_params

    if @spot_register_form.invalid?
      @spot_register_form.add_spot_errors_spot
      set_attached_rule_opt_ids(@spot_register_form.spot)
      render "edit"
    end
  end

  def back_edit
    @spot = Spot.find(params[:id])
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_attached_rule_opt_ids(@spot_register_form.spot)
		render "edit"
	end

  def update
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params], spot: @spot, rules: @spot.rule)
    session.delete(:params)

    if @spot_register_form.save
      SpotHistoryCreator.call(spot: @spot, user: current_user, history: "更新")
      flash[:notice] = "#{@spot_register_form.spot.name}の登録内容を変更しました。"
      redirect_to spot_path(@spot)
    else
      render "edit"
    end
  end

  private

  def form_params
    spot_params = [
      :name,
      :latitude,
      :longitude,
      :address,
      :official_site,
      :allowed_area_id,
      :category_id,
      :image,
    ]

    rule_params = RuleOption.pluck(:id).map  { |i| "#{i}" }

    params.require(:spot_register_form).permit(spot_attributes: spot_params, rule_attributes: [answer: rule_params])
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

  def set_attached_rule_opt_ids(spot)
    attached_rule_opt_ary = spot.decorate.get_checked_rule_opt
    @attached_rule_opt_ids = attached_rule_opt_ary.pluck(:rule_option_id)
  end
end
