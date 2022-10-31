class SpotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_categories, :set_allowed_areas, :set_option_titles, only: [:new, :confirm, :edit]

  def index
    @spots = Spot.all
  end

  def new
    @spot_register_form = SpotRegisterForm.new
  end

  def create
    @spot_register_form = SpotRegisterForm.new(attributes: form_params)

    if @spot_register_form.save
      create_spot_histories("新規登録")
      flash[:notice] = "新しいお出かけスポットを登録しました。"
      redirect_to spots_path
    else
      render "new"
    end
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = Spot.find(params[:id])
    @checked_rules = @spot.rule.pluck(:rule_option_id)
    @spot_register_form = SpotRegisterForm.new(spot: @spot)
  end

  def update
    @spot = Spot.find(params[:id])
    @rules = @spot.rule.where.not(id: nil)
    @spot_register_form = SpotRegisterForm.new(attributes: form_params, spot: @spot, rules: @rules)

    if @spot_register_form.save
      create_spot_histories("更新")
      flash[:notice] = "#{@spot.name}の登録内容を変更しました。"
      redirect_to spot_path(@spot)
    else
      render "edit"
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    redirect_to spots_path
  end

  private

  def form_params
    spot_params = [:name, :latitude, :longitude, :address, :official_site, :image, :allowed_area_id, :category_id]

    @rule_params = []
    RuleOption.pluck(:id).each do |i|
      @rule_params << "#{i}".to_sym
    end

    params.require(:spot_register_form).permit(spot_attributes: spot_params, rule_attributes: [answer: [@rule_params]])
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

  def create_spot_histories(history)
    @spot_register_form.spot_histories.create(user_id: current_user.id, history: history)
  end
end
