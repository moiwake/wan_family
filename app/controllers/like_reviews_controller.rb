class LikeReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @like_review = current_user.like_reviews.create(review_id: params[:review_id])
    redirect_to spot_review_path(params[:spot_id], params[:review_id])
  end

  def destroy
    @like_review = LikeReview.find_by(user_id: current_user.id, review_id: params[:review_id])
    @like_review.destroy
    redirect_to spot_review_path(params[:spot_id], params[:review_id])
  end
end
