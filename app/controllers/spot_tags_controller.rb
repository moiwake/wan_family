class SpotTagsController < ApplicationController
  before_action :set_spot
  before_action :set_tag_names, only: [:new, :edit]

  def index
    set_spot_tags
  end

  def new
    @spot_tag = SpotTag.new
  end

  def create
    @spot_tag = SpotTag.new(spot_tag_params)

    if @spot_tag.save
      set_spot_tags
      render "index"
    else
      set_tag_names
      render "new"
    end
  end

  def edit
    @spot_tag = SpotTag.find(params[:id])
  end

  def update
    @spot_tag = SpotTag.find(params[:id])

    if @spot_tag.update(spot_tag_params)
      set_spot_tags
      render "index"
    else
      set_tag_names
      render "edit"
    end
  end

  def destroy
    @spot_tag = SpotTag.find(params[:id])
    @spot_tag.destroy
    set_spot_tags
    render "index"
  end

  private

  def spot_tag_params
    params.require(:spot_tag).permit(:name, :memo, :user_id, :spot_id)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_spot_tags
    @spot_tags = current_user.spot_tags.where(spot_id: @spot.id)
  end

  def set_tag_names
    @spot_tags = current_user.spot_tags.group(:name).select(:name)
  end
end
