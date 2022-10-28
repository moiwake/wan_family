class SpotsController < ApplicationController
  before_action :authenticate_user!, except: :index
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
      @spot_register_form.spot_histories.build(user_id: current_user.id, history: "新規登録")

      flash[:notice] = "新しいお出かけスポットを登録しました。"
      redirect_to spots_path
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
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
end
