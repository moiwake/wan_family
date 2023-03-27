class SpotsController < ApplicationController
  before_action :authenticate_user!, :set_option_titles, except: [:show]
  before_action :set_favorite_spot, :set_tags_user_put_on_spot, only: [:show]
  before_action :delete_session, only: [:new, :edit]
  after_action  :delete_session, only: [:create, :update]

  def new
    @spot_register_form = SpotRegisterForm.new
  end

  def new_confirm
    @spot_register_form = SpotRegisterForm.new(attributes: form_params)
    session[:params] = form_params

    if @spot_register_form.invalid?
      set_attached_rule_opt_ids(@spot_register_form.spot)
      render "new"
    end

  rescue ActionController::ParameterMissing
    redirect_to back_new_spots_path
  end

  def back_new
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_attached_rule_opt_ids(@spot_register_form.spot)
		render "new"
	end

  def create
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params])

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
    @reviews = @spot.reviews.eager_load(user: :human_avatar_attachment, image: :files_blobs).preload(:like_reviews)
  end

  def edit
    @spot = Spot.find(params[:id])
    set_attached_rule_opt_ids(@spot)
    @spot_register_form = SpotRegisterForm.new(spot: @spot)
  end

  def edit_confirm
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: form_params, spot: @spot)
    session[:params] = form_params

    if @spot_register_form.invalid?
      set_attached_rule_opt_ids(@spot_register_form.spot)
      render "edit"
    end

  rescue ActionController::ParameterMissing
    redirect_to back_edit_spot_path(@spot)
  end

  def back_edit
    @spot = Spot.find(params[:id])
		@spot_register_form = SpotRegisterForm.new(attributes: session[:params])
    set_attached_rule_opt_ids(@spot_register_form.spot)
		render "edit"
	end

  def update
    @spot = Spot.find(params[:id])
    @spot_register_form = SpotRegisterForm.new(attributes: session[:params], spot: @spot)

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
      :prefecture_id,
    ]

    params.require(:spot_register_form).permit(spot_attributes: spot_params, rules_attributes: [[:answer]])
  end

  def set_option_titles
    @titles = OptionTitle.order_default.preload(:rule_options)
  end

  def set_favorite_spot
    if current_user.present?
      @favorite_spot = current_user.favorite_spots.find_by(spot_id: params[:id])
    end
  end

  def set_tags_user_put_on_spot
    if current_user.present?
      @tags_user_put_on_spot = SpotTag.get_tags_user_put_on_spot(user_id: current_user.id, spot_id: params[:id])
    end
  end

  def set_attached_rule_opt_ids(spot)
    attached_rule_opt_ary = spot.decorate.get_checked_rule_opt
    @attached_rule_opt_ids = attached_rule_opt_ary.pluck(:rule_option_id)
  end

  def delete_session
    session.delete(:params)
  end
end
