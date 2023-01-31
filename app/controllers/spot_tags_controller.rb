class SpotTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_spot

  def index
    @spot_tags = current_user.spot_tags.where(spot_id: @spot.id)
  end

  def new
    @spot_tag = SpotTag.new
    @spot_tags = current_user.spot_tags.group(:name).select(:name)
  end

  def create
    @spot_tag = SpotTag.new(spot_tag_params)

    if @spot_tag.save
      @spot_tags = current_user.spot_tags.where(spot_id: @spot.id)
      render "index"
    else
      render "new"
    end
  end

  def destroy
    @spot_tag = SpotTag.find(params[:id])
    @spot_tag.destroy
    @spot_tags = current_user.spot_tags.where(spot_id: @spot.id)
    render "index"
  end

  private

  def spot_tag_params
    params.require(:spot_tag).permit(:name, :memo, :user_id, :spot_id)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
