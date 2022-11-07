class SpotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_categories, :set_allowed_areas, :set_option_titles,
                only: [:new, :back_new, :new_confirm, :create, :edit, :back_edit, :edit_confirm, :update]

  def index
    @spots = Spot.all
  end

  def new
    session.delete(:params)
    @spot_register_form = SpotRegisterForm.new
  end

  def back_new
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_checked_rule_opt_ids(@spot_register_form.spot)
		render "new"
	end

  def new_confirm
    @spot_register_form = SpotRegisterForm.new(attributes: form_params)
    session[:params] = form_params

    if @spot_register_form.invalid?
      @spot_register_form.add_spot_errors_spot
      set_checked_rule_opt_ids(@spot_register_form.spot)
      render "new"
    end
  end

  def create
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    session.delete(:params)

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
    session.delete(:params)
    @spot = Spot.find(params[:id])
    set_checked_rule_opt_ids(@spot)
    @spot_register_form = SpotRegisterForm.new(spot: @spot)
  end

  def back_edit
    @spot = Spot.find(params[:id])
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_checked_rule_opt_ids(@spot_register_form.spot)
		render "edit"
	end

  def edit_confirm
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: form_params, spot: @spot, rules: @spot.rule)
    session[:params] = form_params

    if @spot_register_form.invalid?
      @spot_register_form.add_spot_errors_spot
      set_checked_rule_opt_ids(@spot_register_form.spot)
      render "edit"
    end
  end

  def update
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params], spot: @spot, rules: @spot.rule)
    session.delete(:params)

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

  def set_checked_rule_opt_ids(spot)
    @checked_rule_opt_ids = []
    spot.rule.each do |r|
      if r.answer == "1"
        @checked_rule_opt_ids << r.rule_option_id
      end
    end
  end

  def call_spot_history_creator
    SpotHistoryCreator.call(spot: @spot_register_form.spot, user: current_user)
  end
end
