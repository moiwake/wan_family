class SpotTagsController < ApplicationController
  before_action :set_spot
  before_action :set_created_tag_names, only: [:new, :edit]

  def index
    set_tags_user_put_on_spot
  end

  def new
    @spot_tag = SpotTag.new
    render "new_and_edit"
  end

  def create
    @spot_tag = SpotTag.new(spot_tag_params)

    if @spot_tag.save
      set_tags_user_put_on_spot
      render "index"
    else
      set_created_tag_names
      render "new"
    end
  end

  def edit
    @spot_tag = SpotTag.find(params[:id])
    render "new_and_edit"
  end

  def update
    @spot_tag = SpotTag.find(params[:id])

    if @spot_tag.update(spot_tag_params)
      set_tags_user_put_on_spot
      render "index"
    else
      set_created_tag_names
      render "edit"
    end
  end

  def destroy
    @spot_tag = SpotTag.find(params[:id])
    @spot_tag.destroy
    set_tags_user_put_on_spot
    render "index"
  end

  private

  def spot_tag_params
    params.require(:spot_tag).permit(:name, :memo, :user_id, :spot_id)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def set_tags_user_put_on_spot
    @tags_user_put_on_spot = SpotTag.get_tags_user_put_on_spot(user_id: current_user.id, spot_id: @spot.id)
  end

  def set_created_tag_names
    @created_tag_names = SpotTag.get_tag_names_user_created(user_id: current_user.id)
  end
end
