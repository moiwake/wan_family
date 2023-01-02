class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.create(review_id: params[:review_id])
    redirect_to spot_review_path(params[:spot_id], params[:review_id])
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, review_id: params[:review_id])
    @like.destroy
    redirect_to spot_review_path(params[:spot_id], params[:review_id])
  end
end
